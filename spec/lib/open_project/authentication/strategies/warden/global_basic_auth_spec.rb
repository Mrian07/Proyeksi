

require 'spec_helper'

Strategies = OpenProject::Authentication::Strategies::Warden

describe Strategies::GlobalBasicAuth do
  let(:user) { 'someuser' }
  let(:password) { 'somepassword' }

  let(:config) do
    lambda do
      Strategies::GlobalBasicAuth.configure! user: user, password: password
    end
  end

  context "with UserBasicAuth's reserved username" do
    let(:user) { Strategies::UserBasicAuth.user }

    before do
      allow(Strategies::UserBasicAuth).to receive(:user).and_return('schluessel')
    end

    it 'raises an error' do
      expect(config).to raise_error("global user must not be 'schluessel'")
    end
  end

  context 'with an empty pasword' do
    let(:password) { '' }

    it 'raises an error' do
      expect(config).to raise_error('password must not be empty')
    end
  end

  context 'with digits-only password' do
    let(:password) { 1234 }
    let(:strategy) { Strategies::GlobalBasicAuth.new nil }

    before do
      config.call
    end

    it 'must authenticate successfully' do
      expect(strategy.authenticate_user(user, '1234')).to be_truthy
    end
  end
end
