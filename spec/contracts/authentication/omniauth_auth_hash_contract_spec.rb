#-- encoding: UTF-8



require 'spec_helper'

describe Authentication::OmniauthAuthHashContract do
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

  let(:instance) { described_class.new(auth_hash) }

  subject do
    instance.validate
    instance
  end

  shared_examples_for 'has error on' do |property, message|
    it property do
      expect(subject.errors[property]).to include message
    end
  end

  shared_examples_for 'is valid' do
    it 'is valid' do
      expect(subject).to be_valid
      expect(subject.errors).to be_empty
    end
  end

  describe '#validate_auth_hash' do
    context 'if valid' do
      it_behaves_like 'is valid'
    end

    context 'if invalid' do
      before do
        allow(auth_hash).to receive(:valid?).and_return false
      end

      it_behaves_like 'has error on', :base, I18n.t(:error_omniauth_invalid_auth)
    end
  end

  describe '#validate_auth_hash_not_expired' do
    context 'hash contains valid timestamp' do
      before do
        auth_hash[:timestamp] = Time.now
      end

      it_behaves_like 'is valid'
    end

    context 'hash contains invalid timestamp' do
      before do
        auth_hash[:timestamp] = Time.now - 1.hour
      end

      it_behaves_like 'has error on', :base, I18n.t(:error_omniauth_registration_timed_out)
    end

    context 'hash contains no timestamp' do
      it_behaves_like 'is valid'
    end
  end

  describe '#validate_authorization_callback' do
    let(:auth_double) { double('Authorization', approve?: authorized, message: message) }

    before do
      allow(OpenProject::OmniAuth::Authorization)
        .to(receive(:authorized?))
        .with(auth_hash)
        .and_return(auth_double)
    end

    context 'if authorized' do
      let(:authorized) { true }
      let(:message) { nil }
      it_behaves_like 'is valid'
    end

    context 'if invalid' do
      let(:authorized) { false }
      let(:message) { 'ERROR!' }

      it_behaves_like 'has error on', :base, 'ERROR!'
    end
  end
end
