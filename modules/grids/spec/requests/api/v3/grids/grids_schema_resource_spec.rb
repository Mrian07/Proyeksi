

require 'spec_helper'
require 'rack/test'

describe 'API v3 Grids schema resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:current_user) do
    FactoryBot.create(:user)
  end

  let(:path) { api_v3_paths.grid_schema }

  before do
    login_as(current_user)
  end

  subject(:response) { last_response }

  describe '#GET /grids/schema' do
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
        .not_to have_json_path('page/_links/allowedValues')
    end
  end
end
