

require 'spec_helper'

describe Attachments::PrepareUploadService,
         'integration' do
  shared_let(:container) { FactoryBot.create(:work_package) }
  shared_let(:user) do
    FactoryBot.create :user,
                      member_in_project: container.project,
                      member_with_permissions: %i[view_work_packages edit_work_packages]
  end
  let(:instance) { described_class.new(user: user) }

  let(:file_size) { 6 }
  let(:file_name) { 'document.png' }
  let(:content_type) { "application/octet-stream" }

  let(:call) do
    instance.call filename: file_name,
                  container: container,
                  content_type: content_type,
                  filesize: file_size
  end

  let(:attachment) { call.result }

  it 'returns the attachment' do
    expect(attachment)
      .to be_a(Attachment)
  end

  it 'sets the content_type' do
    expect(attachment.content_type)
      .to eql content_type
  end

  it 'sets the file_size' do
    expect(attachment.filesize)
      .to eql file_size
  end

  it 'sets the file for carrierwave' do
    expect(attachment.file.file.path)
      .to end_with "attachment/file/#{attachment.id}/#{file_name}"
  end

  it 'sets the author' do
    expect(attachment.author)
      .to eql user
  end

  it 'sets the digest to empty string' do
    expect(attachment.digest)
      .to eql ""
  end

  it 'sets the download count to -1' do
    expect(attachment.downloads)
      .to eql -1
  end

  context 'with a special character in the filename' do
    let(:file_name) { "document=number 5.png" }

    it 'sets the file for carrierwave' do
      expect(attachment.file.file.path)
        .to end_with "attachment/file/#{attachment.id}/document_number_5.png"
    end
  end
end
