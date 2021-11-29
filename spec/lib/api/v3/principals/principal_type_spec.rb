

require 'spec_helper'

describe ::API::V3::Principals::PrincipalType do
  let(:principal) { nil }
  subject { described_class.for(instance) }

  shared_examples 'returns api type' do |type|
    it do
      expect(subject).to eq type
    end
  end

  describe 'with a user' do
    let(:instance) { FactoryBot.build_stubbed :user }

    it_behaves_like 'returns api type', :user
  end

  describe 'with a user' do
    let(:instance) { FactoryBot.build_stubbed :user }

    it_behaves_like 'returns api type', :user
  end

  describe 'with a system user' do
    let(:instance) { User.system }

    it_behaves_like 'returns api type', :user
  end

  describe 'with a system user' do
    let(:instance) { FactoryBot.build_stubbed :deleted_user }

    it_behaves_like 'returns api type', :user
  end

  describe 'with anonymous' do
    let(:instance) { User.anonymous }

    it_behaves_like 'returns api type', :user
  end

  describe 'with a group' do
    let(:instance) { FactoryBot.build_stubbed :group }

    it_behaves_like 'returns api type', :group
  end

  describe 'with a placeholder' do
    let(:instance) { FactoryBot.build_stubbed :placeholder_user }

    it_behaves_like 'returns api type', :placeholder_user
  end

  describe 'with an invalid type' do
    let(:instance) { 'whatever' }

    it 'raises an exception' do
      expect { subject }.to raise_error "undefined subclass for whatever"
    end
  end
end
