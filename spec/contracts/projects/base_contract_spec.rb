

require 'spec_helper'
require_relative './shared_contract_examples'

describe Projects::BaseContract do
  let(:project) { Project.new(name: 'Foo', identifier: 'foo', templated: false) }
  let(:contract) { described_class.new(project, current_user) }
  subject { contract.validate }

  describe 'templated attribute' do
    before do
      # Assume the user may manage the project
      allow(contract)
        .to(receive(:validate_user_allowed_to_manage))
        .and_return true

      # Assume templated attribute got changed
      project.templated = true
      expect(project.templated_changed?).to eq true
    end

    context 'as admin' do
      let(:current_user) { FactoryBot.build_stubbed :admin }

      it 'validates the contract' do
        expect(subject).to eq true
      end
    end

    context 'as regular user' do
      let(:current_user) { FactoryBot.build_stubbed :user }

      it 'returns an error on validation' do
        expect(subject).to eq false
        expect(contract.errors.symbols_for(:templated))
          .to match_array [:error_unauthorized]
      end
    end
  end
end
