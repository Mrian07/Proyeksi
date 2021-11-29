

require 'spec_helper'
require 'rest-client'

describe 'OAuth client credentials flow', type: :request do
  include Rack::Test::Methods

  let!(:application) { FactoryBot.create(:oauth_application, client_credentials_user_id: user_id, name: 'Cool API app!') }
  let(:client_secret) { application.plaintext_secret }

  let(:access_token) do
    response = post '/oauth/token',
                    grant_type: 'client_credentials',
                    scope: 'api_v3',
                    client_id: application.uid,
                    client_secret: client_secret

    expect(response).to be_successful
    body = JSON.parse(response.body)
    body['access_token']
  end

  subject do
    # Perform request with it
    headers = { 'HTTP_CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => "Bearer #{access_token}" }
    response = get '/api/v3', {}, headers
    expect(response).to be_successful

    JSON.parse(response.body)
  end

  before do
    expect(access_token).to be_present
    expect(subject).to be_present
  end

  describe 'when application provides client credentials impersonator' do
    let(:user) { FactoryBot.create(:user) }
    let(:user_id) { user.id }

    it 'allows client credential flow as the user' do
      expect(subject.dig('_links', 'user', 'href')).to eq("/api/v3/users/#{user.id}")
    end
  end

  describe 'when application does not provide client credential impersonator' do
    let(:user_id) { nil }

    it 'allows client credential flow as the anonymous user' do
      expect(subject.dig('_links', 'user', 'href')).to be_nil
    end
  end
end
