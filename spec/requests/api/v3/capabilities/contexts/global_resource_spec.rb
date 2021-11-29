

require 'spec_helper'
require 'rack/test'

describe 'API v3 capabilities global context resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  subject(:response) { last_response }

  current_user do
    FactoryBot.create(:user)
  end

  describe 'GET /api/v3/capabilities/contexts/global' do
    let(:path) { api_v3_paths.capabilities_contexts_global }

    before do
      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to be 200
    end

    it 'returns the global context' do
      expect(subject.body)
        .to be_json_eql('CapabilityContext'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql('global'.to_json)
        .at_path('id')
    end
  end
end
