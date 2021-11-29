#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe CustomActions::CuContract do
  include_context 'ModelContract shared context'
  
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:action) do
    FactoryBot.build_stubbed(:custom_action, actions:
                              [CustomActions::Actions::AssignedTo.new])
  end
  let(:contract) { described_class.new(action) }

  describe 'name' do
    it 'is writable' do
      action.name = 'blubs'

      expect_contract_valid
    end
    it 'needs to be set' do
      action.name = nil

      expect_contract_invalid
    end
  end

  describe 'description' do
    it 'is writable' do
      action.description = 'blubs'

      expect_contract_valid
    end
  end

  describe 'actions' do
    it 'is writable' do
      responsible_action = CustomActions::Actions::Responsible.new

      action.actions = [responsible_action]

      expect_contract_valid
    end

    it 'needs to have one' do
      action.actions = []

      expect_contract_invalid actions: :empty
    end

    it 'requires a value if the action requires one' do
      action.actions = [CustomActions::Actions::Status.new([])]

      expect_contract_invalid actions: :empty
    end

    it 'allows only the allowed values' do
      status_action = CustomActions::Actions::Status.new([0])
      allow(status_action)
        .to receive(:allowed_values)
        .and_return([{ value: nil, label: '-' },
                     { value: 1, label: 'some status' }])

      action.actions = [status_action]

      expect_contract_invalid actions: :inclusion
    end

    it 'is not allowed to have an inexistent action' do
      action.actions = [CustomActions::Actions::Inexistent.new]

      expect_contract_invalid actions: :does_not_exist
    end
  end

  describe 'conditions' do
    it 'is writable' do
      action.conditions = [double('some bogus condition', key: 'some', values: 'bogus', validate: true)]

      expect(contract.validate)
        .to be_truthy
    end

    it 'allows only the allowed values' do
      status_condition = CustomActions::Conditions::Status.new([0])
      allow(status_condition)
        .to receive(:allowed_values)
        .and_return([{ value: nil, label: '-' },
                     { value: 1, label: 'some status' }])

      action.conditions = [status_condition]

      expect_contract_invalid conditions: :inclusion
    end

    it 'is not allowed to have an inexistent condition' do
      action.conditions = [CustomActions::Conditions::Inexistent.new]

      expect_contract_invalid conditions: :does_not_exist
    end
  end
end
