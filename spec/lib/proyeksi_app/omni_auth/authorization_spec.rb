

require 'spec_helper'

describe ProyeksiApp::OmniAuth::Authorization do
  describe '.after_login!' do
    let(:auth_hash) { Struct.new(:uid).new 'bar' }
    let(:user)  { FactoryBot.create :user, mail: 'foo@bar.de' }
    let(:state) { Struct.new(:number, :user_email, :uid).new 0, nil, nil }
    let(:collector) { [] }
    let!(:existing_callbacks) { ProyeksiApp::OmniAuth::Authorization.after_login_callbacks.dup }

    before do
      ProyeksiApp::OmniAuth::Authorization.after_login_callbacks.clear

      ProyeksiApp::OmniAuth::Authorization.after_login do |_, _|
        state.number = 42
      end

      ProyeksiApp::OmniAuth::Authorization.after_login do |user, auth|
        state.user_email = user.mail
        state.uid = auth.uid
      end

      ProyeksiApp::OmniAuth::Authorization.after_login do |_, _, context|
        collector << context
      end
    end

    after do
      # Reset existing callbacks to avoid sideeffects
      ProyeksiApp::OmniAuth::Authorization.after_login_callbacks.clear
      callbacks = ProyeksiApp::OmniAuth::Authorization.after_login_callbacks

      existing_callbacks.each do |callback_block|
        callbacks << callback_block
      end
    end

    it 'triggers every callback setting uid to "bar", number to 42 and user_email to foo@bar.de' do
      ProyeksiApp::OmniAuth::Authorization.after_login! user, auth_hash

      expect(state.number).to eq 42
      expect(state.user_email).to eq 'foo@bar.de'
      expect(state.uid).to eq 'bar'
    end

    it 'it optionally passes in a context' do
      context = double(:some_context)
      ProyeksiApp::OmniAuth::Authorization.after_login! user, auth_hash, context
      expect(collector).to include(context)
    end
  end
end
