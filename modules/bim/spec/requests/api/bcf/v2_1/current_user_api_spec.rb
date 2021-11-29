

require 'spec_helper'
require 'rack/test'

require_relative './shared_responses'

describe 'BCF 2.1 current-user resource', type: :request, content_type: :json do
  include Rack::Test::Methods

  let(:current_user) do
    FactoryBot.create(:user)
  end

  subject(:response) { last_response }

  describe 'GET /api/bcf/2.1/current-user' do
    let(:path) { "/api/bcf/2.1/current-user" }

    before do
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        {
          id: current_user.mail,
          name: current_user.name
        }
      end
    end
  end
end
