

require 'spec_helper'

describe Authentication::OmniauthService do
  let(:strategy) { double('Omniauth Strategy', name: 'saml') }
  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: 'google',
      uid: '123545',
      info: { name: 'foo',
              email: 'foo@bar.com',
              first_name: 'foo',
              last_name: 'bar' }
    )
  end
  let(:controller) { double('Controller', session: session_stub) }
  let(:session_stub) { [] }

  let(:instance) { described_class.new(strategy: strategy, auth_hash: auth_hash, controller: controller) }
  let(:user_attributes) { instance.send :build_omniauth_hash_to_user_attributes }

  describe '#contract' do
    before do
      allow(instance.contract)
        .to(receive(:validate))
        .and_return(valid)
    end

    context 'if valid' do
      let(:valid) { true }

      it 'it calls the registration service' do
        expect(Users::RegisterUserService)
          .to(receive(:new))
          .with(kind_of(User))
          .and_call_original

        instance.call
      end
    end

    context 'if invalid' do
      let(:valid) { false }

      it 'it does not call the registration service' do
        expect(Users::RegisterUserService)
          .not_to(receive(:new))

        expect(instance.contract)
          .to(receive(:errors))
          .and_return(['foo'])

        call = instance.call
        expect(call).to be_failure
        expect(call.errors).to eq ['foo']
      end
    end
  end

  describe 'activation of users' do
    let(:call) { instance.call }

    context 'with an active found user' do
      let(:user) { FactoryBot.build_stubbed :user }

      before do
        expect(instance).to receive(:find_existing_user).and_return(user)
        expect(Users::RegisterUserService).not_to receive(:new)
      end

      it 'does not call register user service and logs in the user' do
        # should update the user attributes
        allow(user).to receive(:save)

        expect(OpenProject::OmniAuth::Authorization)
          .to(receive(:after_login!))
          .with(user, auth_hash, instance)

        expect(call).to be_success
        expect(call.result).to eq user
        expect(call.result.firstname).to eq 'foo'
        expect(call.result.lastname).to eq 'bar'
        expect(call.result.mail).to eq 'foo@bar.com'
        expect(user).to have_received(:save)
      end
    end

    context 'without remapping allowed',
            with_settings: { oauth_allow_remapping_of_existing_users?: false } do
      it 'does not look for the user by login' do
        # Regular find
        expect(User)
          .to(receive(:find_by))
          .with(identity_url: 'google:123545')
          .and_return(nil)

        # Remap find
        expect(User)
          .not_to(receive(:find_by_login))
          .with('foo@bar.com')

        call
      end
    end

    context 'with an active user remapped',
            with_settings: { oauth_allow_remapping_of_existing_users?: true } do
      let(:user) { FactoryBot.build_stubbed :user, identity_url: 'foo' }

      before do
        # Regular find
        expect(User)
          .to(receive(:find_by))
          .with(identity_url: 'google:123545')
          .and_return(nil)

        # Remap find
        expect(User)
          .to(receive(:find_by_login))
          .with('foo@bar.com')
          .and_return(user)

        expect(Users::RegisterUserService).not_to receive(:new)
      end

      it 'does not call register user service and logs in the user' do
        # should update the user attributes
        allow(user).to receive(:save)

        expect(OpenProject::OmniAuth::Authorization)
          .to(receive(:after_login!))
          .with(user, auth_hash, instance)

        expect(call).to be_success
        expect(call.result).to eq user
        expect(call.result.firstname).to eq 'foo'
        expect(call.result.lastname).to eq 'bar'
        expect(call.result.mail).to eq 'foo@bar.com'
        expect(user).to have_received(:save)
      end
    end

    describe 'assuming registration/activation worked' do
      let(:register_call) { ServiceResult.new(success: register_success, message: register_message) }
      let(:register_success) { true }
      let(:register_message) { 'It worked!' }

      before do
        expect(Users::RegisterUserService).to receive_message_chain(:new, :call).and_return(register_call)
      end

      describe 'with a new user' do
        it 'calls the register service' do
          expect(call).to be_success

          # The user might get activated in the register service
          expect(instance.user).not_to be_active
          expect(instance.user).to be_new_record

          # Expect notifications to be present (Regression #38066)
          expect(instance.user.notification_settings).not_to be_empty
        end
      end
    end

    describe 'assuming registration/activation failed' do
      let(:register_success) { false }
      let(:register_message) { 'Oh noes :(' }
    end
  end

  describe '#identity_url_from_omniauth' do
    let(:auth_hash) { { provider: 'developer', uid: 'veryuniqueid', info: {} } }
    subject { instance.send(:identity_url_from_omniauth) }

    it 'should return the correct identity_url' do
      expect(subject).to eql('developer:veryuniqueid')
    end

    context 'with uid mapped from info' do
      let(:auth_hash) { { provider: 'developer', uid: 'veryuniqueid', info: { uid: 'internal' } } }

      it 'should return the correct identity_url' do
        expect(subject).to eql('developer:internal')
      end
    end
  end
end
