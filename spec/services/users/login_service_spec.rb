

require 'spec_helper'

describe ::Users::LoginService, type: :model do
  let(:input_user) { FactoryBot.build_stubbed(:user) }
  let(:controller) { double('ApplicationController') }
  let(:session) { {} }
  let(:flash) { ActionDispatch::Flash::FlashHash.new }

  let(:instance) { described_class.new(controller: controller) }

  subject { instance.call(input_user) }

  describe 'session' do
    context 'with an SSO provider' do
      let(:sso_provider) do
        {
          name: 'saml',
          retain_from_session: %i[foo bar]
        }
      end

      before do
        allow(::OpenProject::Plugins::AuthPlugin)
          .to(receive(:login_provider_for))
          .and_return sso_provider

        allow(controller)
          .to(receive(:session))
          .and_return session

        allow(controller)
          .to(receive(:flash))
          .and_return flash

        allow(controller)
          .to(receive(:reset_session)) do
          session.clear
          flash.clear
        end

        allow(input_user)
          .to receive(:log_successful_login)
      end

      context 'if provider retains session values' do
        let(:retained_values) { %i[foo bar] }

        it 'retains present session values' do
          session[:foo] = 'foo value'
          session[:what] = 'should be cleared'

          subject

          expect(session[:foo]).to be_present
          expect(session[:what]).to eq nil
          expect(session[:user_id]).to eq input_user.id
        end
      end

      it 'retains present flash values' do
        flash[:notice] = 'bar'

        subject

        expect(controller.flash[:notice]).to eq 'bar'
      end
    end
  end
end
