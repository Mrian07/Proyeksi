

require 'spec_helper'

describe ::API::V3::Attachments::AttachmentParsingRepresenter do
  let(:current_user) { FactoryBot.build_stubbed :user }
  include API::V3::Utilities::PathHelper

  let(:metadata) do
    data = Hashie::Mash.new
    data.filename = original_file_name
    data.description = original_description
    data.content_type = original_content_type
    data.filesize = original_file_size
    data.digest = original_digest
    data
  end

  let(:original_file_name) { 'a file name' }
  let(:original_description) { 'a description' }
  let(:original_content_type) { 'text/plain' }
  let(:original_file_size) { 42 }
  let(:original_digest) { "0xFF" }

  let(:representer) { described_class.new(metadata, current_user: current_user) }

  describe 'parsing' do
    let(:parsed_hash) do
      {
        'metadata' => {
          'fileName' => 'the parsed name',
          'description' => { 'raw' => 'the parsed description' },
          'contentType' => 'text/html',
          'fileSize' => 43,
          'digest' => '0x00'
        }
      }
    end

    subject { metadata }

    before do
      representer.from_hash parsed_hash
    end

    it { expect(subject.filename).to eql('the parsed name') }
    it { expect(subject.description).to eql('the parsed description') }
    it { expect(subject.content_type).to eql('text/html') }
    it { expect(subject.filesize).to eql(43) }
    it { expect(subject.digest).to eql('0x00') }
  end
end
