

require 'spec_helper'
require 'rack/test'

describe 'API v3 documents resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:document) { FactoryBot.create(:document, project: project) }
  let(:invisible_document) { FactoryBot.create(:document, project: other_project) }
  let(:project) { FactoryBot.create(:project) }
  let(:other_project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i(view_documents) }

  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe 'GET /api/v3/documents' do
    let(:path) { api_v3_paths.documents }

    before do
      document
      invisible_document

      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns a Collection of visible documents' do
      expect(subject.body)
        .to be_json_eql('Collection'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(1.to_json)
        .at_path('total')

      expect(subject.body)
        .to be_json_eql('Document'.to_json)
        .at_path('_embedded/elements/0/_type')

      expect(subject.body)
        .to be_json_eql(document.title.to_json)
        .at_path('_embedded/elements/0/title')
    end
  end

  describe 'GET /api/v3/documents/:id' do
    let(:path) { api_v3_paths.document(document.id) }

    before do
      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the document' do
      expect(subject.body)
        .to be_json_eql('Document'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(document.id.to_json)
        .at_path('id')
    end

    context 'when lacking permissions' do
      let(:permissions) { [] }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql(404)
      end
    end
  end
end
