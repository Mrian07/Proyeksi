

require 'spec_helper'

describe WorkPackages::CreateNoteContract do
  let(:work_package) do
    # As we only want to test the contract, we mock checking whether the work_package is valid
    wp = FactoryBot.build_stubbed(:work_package)
    # we need to clear the changes information because otherwise the
    # contract will complain about all the changes to read_only attributes
    wp.send(:clear_changes_information)
    allow(wp).to receive(:valid?).and_return true

    wp
  end
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:policy_instance) { double('WorkPackagePolicyInstance') }

  subject(:contract) do
    contract = described_class.new(work_package, user)

    contract.send(:'policy=', policy_instance)

    contract
  end

  describe 'note' do
    before do
      work_package.journal_notes = 'blubs'
    end

    context 'if the user has the permissions' do
      before do
        allow(policy_instance).to receive(:allowed?).with(work_package, :comment).and_return true

        contract.validate
      end

      it('is valid') { expect(contract.errors).to be_empty }
    end

    context 'if the user lacks the permissions' do
      before do
        allow(policy_instance).to receive(:allowed?).with(work_package, :comment).and_return false

        contract.validate
      end

      it 'is invalid' do
        expect(contract.errors.symbols_for(:journal_notes))
          .to match_array([:error_unauthorized])
      end
    end
  end

  describe 'subject' do
    before do
      work_package.subject = 'blubs'

      allow(policy_instance).to receive(:allowed?).and_return true

      contract.validate
    end

    it 'is invalid' do
      expect(contract.errors.symbols_for(:subject))
        .to match_array([:error_readonly])
    end
  end
end
