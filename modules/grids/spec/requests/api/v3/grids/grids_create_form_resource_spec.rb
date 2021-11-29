

require 'spec_helper'
require 'rack/test'

describe "POST /api/v3/grids/form", type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:current_user) do
    FactoryBot.create(:user)
  end

  let(:path) { api_v3_paths.create_grid_form }
  let(:params) { {} }
  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe '#post' do
    before do
      post path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql 200
    end

    it 'is of type form' do
      expect(subject.body)
        .to be_json_eql("Form".to_json)
        .at_path('_type')
    end

    it 'contains default data in the payload' do
      expected = {
        "rowCount": 4,
        "columnCount": 5,
        "widgets": [],
        "options": {},
        "_links": {
          "attachments": []
        }
      }

      expect(subject.body)
        .to be_json_eql(expected.to_json)
        .at_path('_embedded/payload')
    end

    it 'has a validation error on scope' do
      expect(subject.body)
        .to be_json_eql("Scope is not set to one of the allowed values.".to_json)
        .at_path('_embedded/validationErrors/scope/message')
    end

    it 'does not have a commit link' do
      expect(subject.body)
        .not_to have_json_path('_links/commit')
    end
  end
end
