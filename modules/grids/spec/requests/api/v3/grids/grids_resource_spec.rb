

require 'spec_helper'
require 'rack/test'

describe 'API v3 Grids resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:current_user) do
    FactoryBot.create(:user)
  end

  before do
    login_as(current_user)
  end

  subject(:response) { last_response }

  describe '#get INDEX' do
    let(:path) { api_v3_paths.grids }

    before do
      get path
    end

    it 'responds with 200 OK' do
      expect(subject.status).to eq(200)
    end
  end

  describe '#post' do
    let(:path) { api_v3_paths.grids }

    before do
      post path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    context 'without a page link' do
      let(:params) do
        {
          "rowCount": 5,
          "columnCount": 5,
          "widgets": [{
            "identifier": "work_packages_assigned",
            "startRow": 2,
            "endRow": 4,
            "startColumn": 2,
            "endColumn": 5
          }]
        }.with_indifferent_access
      end

      it 'responds with 422' do
        expect(subject.status).to eq(422)
      end

      it 'does not create a grid' do
        expect(Grids::Grid.count)
          .to eql(0)
      end

      it 'returns the errors' do
        expect(subject.body)
          .to be_json_eql('Error'.to_json)
          .at_path('_type')

        expect(subject.body)
          .to be_json_eql("Scope is not set to one of the allowed values.".to_json)
          .at_path('message')
      end
    end
  end
end
