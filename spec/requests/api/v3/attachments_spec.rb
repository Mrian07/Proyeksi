

require 'spec_helper'
require_relative 'attachments/attachment_resource_shared_examples'

describe API::V3::Attachments::AttachmentsAPI, type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper
  include FileHelpers

  let(:current_user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }

  let(:project) { FactoryBot.create(:project, public: false) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { [:add_work_packages] }

  context(
    'with missing permissions',
    with_config: {
      attachments_storage: :fog,
      fog: { credentials: { provider: 'AWS' } }
    }
  ) do
    let(:permissions) { [] }

    let(:request_path) { api_v3_paths.prepare_new_attachment_upload }
    let(:request_parts) { { metadata: metadata.to_json, file: file } }
    let(:metadata) { { fileName: 'cat.png' } }
    let(:file) { mock_uploaded_file(name: 'original-filename.txt') }

    before do
      post request_path, request_parts
    end

    it 'should forbid to prepare attachments' do
      expect(last_response.status).to eq 403
    end
  end

  it_behaves_like 'it supports direct uploads' do
    let(:request_path) { api_v3_paths.prepare_new_attachment_upload }
    let(:container_href) { nil }

    describe 'GET /uploaded' do
      let(:digest) { "" }
      let(:attachment) do
        FactoryBot.create :attachment, digest: digest, author: current_user, container: nil, container_type: nil, downloads: -1
      end

      before do
        get "/api/v3/attachments/#{attachment.id}/uploaded"
      end

      context 'with no pending attachments' do
        let(:digest) { "0xFF" }

        it 'should return 404' do
          expect(last_response.status).to eq 404
        end
      end

      context 'with a pending attachment' do
        it 'should enqueue a FinishDirectUpload job' do
          expect(::Attachments::FinishDirectUploadJob).to have_been_enqueued.at_least(1)
        end

        it 'should respond with HTTP OK' do
          expect(last_response.status).to eq 200
        end

        it 'should return the attachment representation' do
          json = JSON.parse last_response.body

          expect(json["_type"]).to eq "Attachment"
        end
      end
    end
  end
end
