

require 'spec_helper'

# Concern is included into AccountController and depends on methods available there
describe AccountController, type: :controller do
  let(:omniauth_strategy) { double('Google Strategy', name: 'google') }
  let(:omniauth_hash) do
    OmniAuth::AuthHash.new(
      provider: 'google',
      strategy: omniauth_strategy,
      uid: '123545',
      info: { name: 'foo',
              email: 'foo@bar.com',
              first_name: 'foo',
              last_name: 'bar' }
    )
  end

  before do
    request.env['omniauth.auth'] = omniauth_hash
    request.env['omniauth.strategy'] = omniauth_strategy
  end

  after do
    User.current = nil
  end

  context 'GET #omniauth_login', with_settings: { self_registration: Setting::SelfRegistration.automatic } do
    describe 'with on-the-fly registration' do
      context 'providing all required fields' do
        before do
          request.env['omniauth.origin'] = 'https://example.net/some_back_url'
          post :omniauth_login, params: { provider: :google }
        end

        it 'registers the user on-the-fly' do
          user = User.find_by_login('foo@bar.com')
          expect(user).to be_an_instance_of(User)
          expect(user.auth_source_id).to be_nil
          expect(user.current_password).to be_nil
          expect(user.identity_url).to eql('google:123545')
          expect(user.login).to eql('foo@bar.com')
          expect(user.firstname).to eql('foo')
          expect(user.lastname).to eql('bar')
          expect(user.mail).to eql('foo@bar.com')
        end

        it 'redirects to the first login page with a back_url' do
          expect(response).to redirect_to(home_url(first_time_user: true))
        end
      end

      describe 'strategy uid mapping override' do
        let(:omniauth_hash) do
          OmniAuth::AuthHash.new(
            provider: 'google',
            strategy: omniauth_strategy,
            uid: 'foo',
            info: {
              uid: 'internal',
              email: 'whattheheck@example.com',
              first_name: 'what',
              last_name: 'theheck'
            }
          )
        end

        it 'takes the uid from the mapped attributes' do
          post :omniauth_login, params: { provider: :google }

          user = User.find_by_login('whattheheck@example.com')
          expect(user).to be_an_instance_of(User)
          expect(user.identity_url).to eq 'google:internal'
        end
      end

      describe 'strategy attribute mapping override' do
        let(:omniauth_hash) do
          OmniAuth::AuthHash.new(
            provider: 'google',
            strategy: omniauth_strategy,
            uid: 'foo',
            info: { email: 'whattheheck@example.com',
                    first_name: 'what',
                    last_name: 'theheck' },
            extra: { raw_info: {
              real_uid: 'bar@example.org',
              first_name: 'foo',
              last_name: 'bar'
            } }
          )
        end


        context 'available' do
          it 'merges the strategy mapping' do
            allow(omniauth_strategy).to receive(:omniauth_hash_to_user_attributes) do |auth|
              raw_info = auth[:extra][:raw_info]
              {
                login: raw_info[:real_uid],
                firstname: raw_info[:first_name],
                lastname: raw_info[:last_name]
              }
            end

            expect(omniauth_strategy).to receive(:omniauth_hash_to_user_attributes)

            post :omniauth_login, params: { provider: :google }

            user = User.find_by_login('bar@example.org')
            expect(user).to be_an_instance_of(User)
            expect(user.firstname).to eql('foo')
            expect(user.lastname).to eql('bar')
          end
        end

        context 'unavailable' do
          it 'keeps the default mapping' do
            post :omniauth_login, params: { provider: :google }

            user = User.find_by_login('whattheheck@example.com')
            expect(user).to be_an_instance_of(User)
            expect(user.firstname).to eql('what')
            expect(user.lastname).to eql('theheck')
          end
        end
      end

      context 'not providing all required fields' do
        let(:omniauth_hash) do
          OmniAuth::AuthHash.new(
            provider: 'google',
            uid: '123545',
            info: { name: 'foo', email: 'foo@bar.com' }
            # first_name and last_name not set
          )
        end

        it 'renders user form' do
          post :omniauth_login, params: { provider: :google }
          expect(response).to render_template :register
          expect(assigns(:user).mail).to eql('foo@bar.com')
        end

        it 'registers user via post' do
          expect(ProyeksiApp::OmniAuth::Authorization).to receive(:after_login!) do |user, auth_hash|
            new_user = User.find_by_login('login@bar.com')
            expect(user).to eq new_user
            expect(auth_hash).to include(omniauth_hash)
          end

          auth_source_registration = omniauth_hash.merge(
            omniauth: true,
            timestamp: Time.new
          )
          session[:auth_source_registration] = auth_source_registration
          post :register,
               params: {
                 user: {
                   login: 'login@bar.com',
                   firstname: 'Foo',
                   lastname: 'Smith',
                   mail: 'foo@bar.com'
                 }
               }
          expect(response).to redirect_to home_url(first_time_user: true)

          user = User.find_by_login('login@bar.com')
          expect(user).to be_an_instance_of(User)
          expect(user.auth_source_id).to be_nil
          expect(user.current_password).to be_nil
          expect(user.identity_url).to eql('google:123545')
        end

        context 'after a timeout expired' do
          before do
            session[:auth_source_registration] = omniauth_hash.merge(
              omniauth: true,
              timestamp: Time.new - 42.days
            )
          end

          it 'does not register the user when providing all the missing fields' do
            post :register,
                 params: {
                   user: {
                     firstname: 'Foo',
                     lastname: 'Smith',
                     mail: 'foo@bar.com'
                   }
                 }

            expect(response).to redirect_to signin_path
            expect(flash[:error]).to eq(I18n.t(:error_omniauth_registration_timed_out))
            expect(User.find_by_login('foo@bar.com')).to be_nil
          end

          it 'does not register the user when providing all the missing fields' do
            post :register,
                 params: {
                   user: {
                     firstname: 'Foo',
                     # lastname intentionally not provided
                     mail: 'foo@bar.com'
                   }
                 }

            expect(response).to redirect_to signin_path
            expect(flash[:error]).to eq(I18n.t(:error_omniauth_registration_timed_out))
            expect(User.find_by_login('foo@bar.com')).to be_nil
          end
        end
      end

      context 'with self-registration disabled',
              with_settings: { self_registration: Setting::SelfRegistration.disabled } do
        let(:omniauth_hash) do
          OmniAuth::AuthHash.new(
            provider: 'google',
            uid: '123',
            info: { name: 'foo',
                    email: 'foo@bar.com',
                    first_name: 'foo',
                    last_name: 'bar' }
          )
        end

        before do
          request.env['omniauth.origin'] = 'https://example.net/some_back_url'

          post :omniauth_login, params: { provider: :google }
        end

        it 'redirects to signin_path' do
          expect(response).to redirect_to signin_path
        end

        it 'shows the right flash message' do
          expect(flash[:error]).to eq(I18n.t('account.error_self_registration_disabled'))
        end
      end
    end

    describe 'login' do
      let(:omniauth_hash) do
        OmniAuth::AuthHash.new(
          provider: 'google',
          uid: '123545',
          info: { name: 'foo',
                  last_name: 'bar',
                  email: 'foo@bar.com' }
        )
      end

      let(:user) do
        FactoryBot.build(:user, force_password_change: false,
                                identity_url: 'google:123545')
      end

      context 'with an active account' do
        before do
          user.save!
        end

        it 'should sign in the user after successful external authentication' do
          post :omniauth_login, params: { provider: :google }

          expect(response).to redirect_to my_page_path
        end

        it 'should log a successful login' do
          post_at = Time.now.utc
          post :omniauth_login, params: { provider: :google }

          user.reload
          expect(user.last_login_on.utc.to_i).to be >= post_at.utc.to_i
        end

        describe 'authorization' do
          let(:config) do
            Struct.new(:google_name, :global_email).new 'foo', 'foo@bar.com'
          end

          before do
            ProyeksiApp::OmniAuth::Authorization.callbacks.clear

            # Let's set up a couple of authorization callbacks to see if the mechanism
            # works as intended.

            ProyeksiApp::OmniAuth::Authorization.authorize_user provider: :google do |dec, auth|
              if auth.info.name == config.google_name
                dec.approve
              else
                dec.reject "Go away #{auth.info.name}!"
              end
            end

            ProyeksiApp::OmniAuth::Authorization.authorize_user do |dec, auth|
              if auth.info.email == config.global_email
                dec.approve
              else
                dec.reject "I only want to see #{config[:global_email]} here."
              end
            end

            # ineffective callback
            ProyeksiApp::OmniAuth::Authorization.authorize_user provider: :foobar do |dec, _|
              dec.reject 'Though shalt not pass!'
            end

            # free for all callback
            ProyeksiApp::OmniAuth::Authorization.authorize_user do |dec, _|
              dec.approve
            end
          end

          after do
            ProyeksiApp::OmniAuth::Authorization.callbacks.clear
          end

          it 'works' do
            expect(ProyeksiApp::OmniAuth::Authorization).to receive(:after_login!) do |u, auth|
              expect(u).to eq user
              expect(auth).to eq omniauth_hash
            end

            post :omniauth_login, params: { provider: :google }

            expect(response).to redirect_to my_page_path
          end

          context 'with wrong email address' do
            before do
              config.global_email = 'other@mail.com'
            end

            it 'is rejected against google' do
              expect(ProyeksiApp::OmniAuth::Authorization).not_to receive(:after_login!).with(user)

              post :omniauth_login, params: { provider: :google }

              expect(response).to redirect_to signin_path
              expect(flash[:error]).to eq 'I only want to see other@mail.com here.'
            end

            it 'is rejected against any other provider too' do
              expect(ProyeksiApp::OmniAuth::Authorization).not_to receive(:after_login!).with(user)

              omniauth_hash.provider = 'any other'
              post :omniauth_login, params: { provider: :google }

              expect(response).to redirect_to signin_path
              expect(flash[:error]).to eq 'I only want to see other@mail.com here.'
            end
          end

          context 'with the wrong name' do
            render_views

            before do
              config.google_name = 'hans'
            end

            it 'is rejected against google' do
              expect(ProyeksiApp::OmniAuth::Authorization).not_to receive(:after_login!).with(user)

              post :omniauth_login, params: { provider: :google }

              expect(response).to redirect_to signin_path
              expect(flash[:error]).to eq 'Go away foo!'
            end

            it 'is approved against any other provider' do
              expect(ProyeksiApp::OmniAuth::Authorization).to receive(:after_login!) do |u|
                new_user = User.find_by identity_url: 'some other:123545'

                expect(u).to eq new_user
              end

              omniauth_hash.provider = 'some other'

              post :omniauth_login, params: { provider: :google }

              expect(response).to redirect_to home_url(first_time_user: true)
              # The authorization is successful which results in the registration
              # of a new user in this case because we changed the provider
              # and there isn't a user with that identity URL yet.
            end

            # ... and to confirm that, here's what happens when the authorization fails
            it 'is rejected against any other provider with the wrong email' do
              expect(ProyeksiApp::OmniAuth::Authorization).not_to receive(:after_login!).with(user)

              omniauth_hash.provider = 'yet another'
              config.global_email = 'yarrrr@joro.es'

              post :omniauth_login, params: { provider: :google }

              expect(response).to redirect_to signin_path
              expect(flash[:error]).to eq 'I only want to see yarrrr@joro.es here.'
            end
          end
        end
      end

      context 'with a registered and not activated accout',
              with_settings: { self_registration: Setting::SelfRegistration.by_email } do
        before do
          user.register
          user.save!

          post :omniauth_login, params: { provider: :google }
        end

        it 'should show an error about a not activated account' do
          expect(flash[:error]).to eql(I18n.t('account.error_inactive_activation_by_mail'))
        end

        it 'should redirect to signin_path' do
          expect(response).to redirect_to signin_path
        end
      end

      context 'with an invited user and self registration disabled',
              with_settings: { self_registration: Setting::SelfRegistration.disabled } do
        before do
          user.invite
          user.save!

          post :omniauth_login, params: { provider: :google }
        end

        it 'should show a notice about the activated account' do
          expect(flash[:notice]).to eq(I18n.t('notice_account_registered_and_logged_in'))
        end

        it 'should activate the user' do
          expect(user.reload).to be_active
        end
      end

      context 'with a locked account',
              with_settings: { brute_force_block_after_failed_logins?: false } do
        before do
          user.lock
          user.save!

          post :omniauth_login, params: { provider: :google }
        end

        it 'should show an error indicating a failed login' do
          expect(flash[:error]).to eql(I18n.t(:notice_account_invalid_credentials))
        end

        it 'should redirect to signin_path' do
          expect(response).to redirect_to signin_path
        end
      end
    end

    describe 'with an invalid auth_hash' do
      let(:omniauth_hash) do
        OmniAuth::AuthHash.new(
          provider: 'google',
          # id is deliberately missing here to make the auth_hash invalid
          info: { name: 'foo',
                  email: 'foo@bar.com' }
        )
      end

      before do
        post :omniauth_login, params: { provider: :google }
      end

      it 'should respond with an error' do
        expect(flash[:error]).to include 'The authentication information returned from the identity provider was invalid.'
        expect(response).to redirect_to signin_path
      end

      it 'should not sign in the user' do
        expect(controller.send(:current_user).logged?).to be_falsey
      end

      it 'does not set registration information in the session' do
        expect(session[:auth_source_registration]).to be_nil
      end
    end

    describe 'Error occurs during authentication' do
      it 'should redirect to login page' do
        post :omniauth_failure
        expect(response).to redirect_to signin_path
      end

      it 'should log a warn message' do
        expect(Rails.logger).to receive(:warn).with('invalid_credentials')
        post :omniauth_failure, params: { message: 'invalid_credentials' }
      end
    end
  end
end
