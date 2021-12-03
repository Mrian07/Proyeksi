

require 'spec_helper'

##
describe AccountController, 'Auth header logout', type: :controller do
  render_views

  let!(:auth_source) { DummyAuthSource.create name: "Dummy LDAP" }
  let!(:user) { FactoryBot.create :user, login: login, auth_source_id: auth_source.id }
  let(:login) { "h.wurst" }

  before do
    if sso_config
      allow(ProyeksiApp::Configuration)
        .to receive(:auth_source_sso)
        .and_return(sso_config)
    end
  end

  describe 'logout' do
    context 'when a logout URL is present' do
      let(:sso_config) do
        {
          logout_url: 'https://example.org/foo?logout=true'
        }
      end

      context 'and the user came from auth source' do
        before do
          login_as user
          session[:user_from_auth_header] = true
          get :logout
        end

        it 'is redirected to the logout URL' do
          expect(response).to redirect_to 'https://example.org/foo?logout=true'
        end
      end

      context 'and the user did not come from auth source' do
        before do
          login_as user
          session[:user_from_auth_header] = nil
          get :logout
        end

        it 'is redirected to the home URL' do
          expect(response).to redirect_to home_url
        end
      end
    end
  end
end
