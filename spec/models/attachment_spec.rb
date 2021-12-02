
require 'spec_helper'

describe Attachment, type: :model do
  let(:stubbed_author) { FactoryBot.build_stubbed(:user) }
  let(:author) { FactoryBot.create :user }
  let(:long_description) { 'a' * 300 }
  let(:work_package) { FactoryBot.create :work_package }
  let(:stubbed_work_package) { FactoryBot.build_stubbed :stubbed_work_package }
  let(:file) { FactoryBot.create :uploaded_jpg, name: 'test.jpg' }
  let(:second_file) { FactoryBot.create :uploaded_jpg, name: 'test2.jpg' }
  let(:container) { stubbed_work_package }

  let(:attachment) do
    FactoryBot.build(
      :attachment,
      author: author,
      container: container,
      content_type: nil, # so that it is detected
      file: file
    )
  end
  let(:stubbed_attachment) do
    FactoryBot.build_stubbed(
      :attachment,
      author: stubbed_author,
      container: container
    )
  end

  describe 'validations' do
    it 'is valid' do
      expect(stubbed_attachment)
        .to be_valid
    end

    context 'with a long description' do
      before do
        stubbed_attachment.description = long_description
        stubbed_attachment.valid?
      end

      it 'raises an error regarding description length' do
        expect(stubbed_attachment.errors[:description])
          .to match_array [I18n.t('activerecord.errors.messages.too_long', count: 255)]
      end
    end

    context 'without a container' do
      let(:container) { nil }

      it 'is valid' do
        expect(stubbed_attachment)
          .to be_valid
      end
    end

    context 'without a container first and then setting a container' do
      let(:container) { nil }

      before do
        stubbed_attachment.container = work_package
      end

      it 'is valid' do
        expect(stubbed_attachment)
          .to be_valid
      end
    end

    context 'with a container first and then removing the container' do
      before do
        stubbed_attachment.container = nil
      end

      it 'notes the field as unchangeable' do
        stubbed_attachment.valid?

        expect(stubbed_attachment.errors.symbols_for(:container))
          .to match_array [:unchangeable]
      end
    end

    context 'with a container first and then changing the container_id' do
      before do
        stubbed_attachment.container_id = stubbed_attachment.container_id + 1
      end

      it 'notes the field as unchangeable' do
        stubbed_attachment.valid?

        expect(stubbed_attachment.errors.symbols_for(:container))
          .to match_array [:unchangeable]
      end
    end

    context 'with a container first and then changing the container_type' do
      before do
        stubbed_attachment.container_type = 'WikiPage'
      end

      it 'notes the field as unchangeable' do
        stubbed_attachment.valid?

        expect(stubbed_attachment.errors.symbols_for(:container))
          .to match_array [:unchangeable]
      end
    end
  end

  describe '#containered?' do
    it 'is false if the attachment has no container' do
      stubbed_attachment.container = nil

      expect(stubbed_attachment)
        .not_to be_containered
    end

    it 'is true if the attachment has a container' do
      expect(stubbed_attachment)
        .to be_containered
    end
  end

  describe 'create' do
    it('creates a jpg file called test') do
      expect(File.exists?(attachment.diskfile.path)).to eq true
    end

    it('has the content type "image/jpeg"') do
      expect(attachment.content_type).to eq 'image/jpeg'
    end

    it 'has the correct filesize' do
      expect(attachment.filesize)
        .to eql file.size
    end

    it 'creates an md5 digest' do
      expect(attachment.digest)
        .to eql Digest::MD5.file(file.path).hexdigest
    end
  end

  describe 'two attachments with same file name' do
    let(:second_file) { FactoryBot.create :uploaded_jpg, name: file.original_filename }

    it 'does not interfere' do
      a1 = Attachment.create!(container: work_package,
                              file: file,
                              author: author)
      a2 = Attachment.create!(container: work_package,
                              file: second_file,
                              author: author)

      expect(a1.diskfile.path)
        .not_to eql a2.diskfile.path
    end
  end

  ##
  # The tests assumes the default, file-based storage is configured and tests against that.
  # I.e. it does not test fog attachments being deleted from the cloud storage (such as S3).
  describe '#destroy' do
    before do
      attachment.save!

      expect(File.exists?(attachment.file.path)).to eq true

      attachment.destroy
      attachment.run_callbacks(:commit)
      # triggering after_commit callbacks manually as they are not triggered during rspec runs
      # though in dev/production mode destroy does trigger these callbacks
    end

    it "deletes the attachment's file" do
      expect(File.exists?(attachment.file.path)).to eq false
    end
  end

  # We just use with_direct_uploads here to make sure the
  # FogAttachment class is defined and Fog is mocked.
  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe "#external_url", with_direct_uploads: true do
    let(:author) { FactoryBot.create :user }

    let(:image_path) { Rails.root.join("spec/fixtures/files/image.png") }
    let(:text_path) { Rails.root.join("spec/fixtures/files/testfile.txt") }
    let(:binary_path) { Rails.root.join("spec/fixtures/files/textfile.txt.gz") }

    let(:image_attachment) { FogAttachment.new author: author, file: File.open(image_path) }
    let(:text_attachment) { FogAttachment.new author: author, file: File.open(text_path) }
    let(:binary_attachment) { FogAttachment.new author: author, file: File.open(binary_path) }

    shared_examples "it has a temporary download link" do
      let(:url_options) { {} }
      let(:query) { attachment.external_url(**url_options).to_s.split("?").last }

      it "should have a default expiry time" do
        expect(query).to include "X-Amz-Expires="
        expect(query).not_to include "X-Amz-Expires=3600"
      end

      context "with a custom expiry time" do
        let(:url_options) { { expires_in: 1.hour } }

        it "should use that time" do
          expect(query).to include "X-Amz-Expires=3600"
        end
      end

      context 'with expiry time exceeding maximum' do
        let(:url_options) { { expires_in: 1.year } }

        it "uses the allowed max" do
          expect(query).to include "X-Amz-Expires=#{ProyeksiApp::Configuration.fog_download_url_expires_in}"
        end
      end
    end

    shared_examples "it uses content disposition inline" do
      let(:attachment) { raise "define me!" }

      describe 'the external url (for remote attachments)' do
        it 'contains inline content disposition without the filename' do
          expect(attachment.external_url.to_s).to include "response-content-disposition=inline&"
        end
      end

      describe 'content disposition (for local attachments)' do
        it 'is inline, including the filename' do
          expect(attachment.content_disposition).to eq "inline; filename=#{attachment.filename}"
        end
      end
    end

    describe "for an image file" do
      before { image_attachment.save! }

      it_behaves_like "it uses content disposition inline" do
        let(:attachment) { image_attachment }
      end

      # this is independent from the type of file uploaded so we just test this for the first one
      it_behaves_like "it has a temporary download link" do
        let(:attachment) { image_attachment }
      end
    end

    describe "for a text file" do
      before { text_attachment.save! }

      it_behaves_like "it uses content disposition inline" do
        let(:attachment) { text_attachment }
      end
    end

    describe 'for a video file' do
      let(:attachment) { described_class.new }

      it 'assumes it to be inlineable' do
        %w[video/webm video/mp4 video/quicktime].each do |content_type|
          attachment.content_type = content_type
          expect(attachment).to be_inlineable, "#{content_type} should be inlineable"
        end
      end
    end

    describe "for a binary file" do
      before { binary_attachment.save! }

      it "should make S3 use content_disposition 'attachment; filename=...'" do
        expect(binary_attachment.content_disposition).to eq "attachment; filename=textfile.txt.gz"
        expect(binary_attachment.external_url.to_s).to include "response-content-disposition=attachment"
      end
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers

  describe 'full text extraction job on commit' do
    let(:created_attachment) do
      FactoryBot.create(:attachment,
                        author: author,
                        container: container)
    end

    shared_examples_for 'runs extraction' do
      it 'runs extraction' do
        extraction_with_id = nil

        allow(ExtractFulltextJob)
          .to receive(:perform_later) do |id|
          extraction_with_id = id
        end

        attachment.save

        expect(extraction_with_id).to eql attachment.id
      end
    end

    shared_examples_for 'does not run extraction' do
      it 'does not run extraction' do
        created_attachment

        expect(ExtractFulltextJob)
          .not_to receive(:perform_later)

        created_attachment.save
      end
    end

    context 'for a work package' do
      let(:work_package) { FactoryBot.create(:work_package) }
      let(:container) { work_package }

      context 'on create' do
        it_behaves_like 'runs extraction'
      end

      context 'on update' do
        it_behaves_like 'does not run extraction'
      end
    end

    context 'for a wiki page' do
      let(:wiki_page) { FactoryBot.create(:wiki_page) }
      let(:container) { wiki_page }

      context 'on create' do
        it_behaves_like 'does not run extraction'
      end

      context 'on update' do
        it_behaves_like 'does not run extraction'
      end
    end

    context 'without a container' do
      let(:container) { nil }

      context 'on create' do
        it_behaves_like 'runs extraction'
      end

      context 'on update' do
        it_behaves_like 'does not run extraction'
      end
    end
  end
end
