

require 'spec_helper'
require 'rack/test'

describe 'API v3 Time entry schema resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  let(:permissions) { [:view_time_entries] }

  let(:path) { api_v3_paths.time_entry_schema }

  before do
    login_as(current_user)
  end

  subject(:response) { last_response }

  describe '#GET /time_entries/schema' do
    before do
      get path
    end

    it 'responds with 200 OK' do
      expect(subject.status).to eq(200)
    end

    it 'returns a schema' do
      expect(subject.body)
        .to be_json_eql('Schema'.to_json)
        .at_path '_type'
    end

    it 'does not embed' do
      expect(subject.body)
        .not_to have_json_path('project/_links/allowedValues')
    end

    context 'if lacking permissions' do
      let(:permissions) { [] }

      it 'responds with 403' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
