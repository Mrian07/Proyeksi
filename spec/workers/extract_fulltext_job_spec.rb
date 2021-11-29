#-- encoding: UTF-8



require 'spec_helper'

describe ExtractFulltextJob, type: :job do
  subject(:extracted_attributes) do
    perform_enqueued_jobs

    attachment.reload

    Attachment.connection.select_one <<~SQL.squish
      SELECT
        fulltext,
        fulltext_tsv,
        file_tsv
      FROM
        attachments
      WHERE
        id = #{attachment.id}
    SQL
  end

  let(:text) { 'lorem ipsum' }
  let(:attachment) do
    FactoryBot.create(:attachment).tap do |attachment|
      expect(ExtractFulltextJob)
        .to have_been_enqueued
        .with(attachment.id)

      allow(Attachment)
        .to receive(:find_by)
              .with(id: attachment.id)
              .and_return(attachment)
    end
  end

  context "with successful text extraction" do
    before do
      allow_any_instance_of(Plaintext::Resolver).to receive(:text).and_return(text)
    end

    context 'attachment is readable' do
      before do
        allow(attachment).to receive(:readable?).and_return(true)
      end

      it 'updates the attachment\'s DB record with fulltext, fulltext_tsv, and file_tsv' do
        expect(extracted_attributes['fulltext']).to eq text
        expect(extracted_attributes['fulltext_tsv'].size).to be > 0
        expect(extracted_attributes['file_tsv'].size).to be > 0
      end

      context 'without text extracted' do
        let(:text) { nil }

        # include_examples 'no fulltext but file name saved as TSV'
        it 'updates the attachment\'s DB record with file_tsv' do
          expect(extracted_attributes['fulltext']).to be_blank
          expect(extracted_attributes['fulltext_tsv']).to be_blank
          expect(extracted_attributes['file_tsv'].size).to be > 0
        end
      end
    end
  end

  shared_examples 'only file name indexed' do
    it 'updates the attachment\'s DB record with file_tsv' do
      expect(extracted_attributes['fulltext']).to be_blank
      expect(extracted_attributes['fulltext_tsv']).to be_blank
      expect(extracted_attributes['file_tsv'].size).to be > 0
    end
  end

  context 'with the file not readable' do
    before do
      allow(attachment).to receive(:readable?).and_return(false)
    end

    include_examples 'only file name indexed'
  end

  context 'with exception in extraction' do
    let(:exception_message) { 'boom-internal-error' }
    let(:logger) { Rails.logger }

    before do
      allow_any_instance_of(Plaintext::Resolver).to receive(:text).and_raise(exception_message)

      allow(logger).to receive(:error)

      allow(attachment).to receive(:readable?).and_return(true)
    end

    it 'logs the error' do
      extracted_attributes
      expect(logger).to have_received(:error).with(/boom-internal-error/)
    end

    include_examples 'only file name indexed'
  end
end
