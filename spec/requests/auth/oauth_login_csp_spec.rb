#-- encoding: UTF-8



require 'spec_helper'

describe 'CSP appends on login form from oauth',
         type: :rails_request do
  let!(:redirect_uri) { 'https://foobar.com' }
  let!(:oauth_app) { FactoryBot.create(:oauth_application, redirect_uri: redirect_uri) }
  let(:oauth_path) do
    "/oauth/authorize?response_type=code&client_id=#{oauth_app.uid}&redirect_uri=#{CGI.escape(redirect_uri)}&scope=api_v3"
  end

  context 'when login required', with_settings: { login_required: true } do
    it 'appends given CSP appends from flash' do
      get oauth_path

      csp = response.headers['Content-Security-Policy']
      expect(csp).to include "form-action 'self' https://foobar.com/;"

      location = response.headers['Location']
      expect(location).to include("/login?back_url=#{CGI.escape(oauth_path)}")
    end
  end
end
