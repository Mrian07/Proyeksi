

require 'spec_helper'
require 'rack/test'

require_relative './shared_responses'

describe 'BCF 2.1 auth resource', type: :request, content_type: :json do
  include Rack::Test::Methods

  let(:current_user) do
    FactoryBot.create(:user)
  end

  subject(:response) { last_response }

  describe 'GET /api/bcf/2.1/auth' do
    let(:path) { "/api/bcf/2.1/auth" }

    before do
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        {
          "oauth2_auth_url": "http://localhost:3000/oauth/authorize",
          "oauth2_token_url": "http://localhost:3000/oauth/token",
          "http_basic_supported": false,
          "supported_oauth2_flows": %w(authorization_code_grant client_credentials)
        }
      end
    end
  end
end
