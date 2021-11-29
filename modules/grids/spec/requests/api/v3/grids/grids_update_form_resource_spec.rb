

require 'spec_helper'
require 'rack/test'

describe "PATCH /api/v3/grids/:id/form", type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:current_user) do
    FactoryBot.create(:user)
  end

  let(:params) { {} }
  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe '#post' do
    before do
      post path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    context 'for a non existing grid' do
      let(:path) { api_v3_paths.grid_form(5) }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql 404
      end
    end
  end
end
