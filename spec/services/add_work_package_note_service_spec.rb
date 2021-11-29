#-- encoding: UTF-8



require 'spec_helper'

describe AddWorkPackageNoteService, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:work_package) { FactoryBot.build_stubbed(:work_package) }
  let(:instance) do
    described_class.new(user: user,
                        work_package: work_package)
  end

  describe '.contract' do
    it 'uses the CreateNoteContract contract' do
      expect(instance.contract_class).to eql WorkPackages::CreateNoteContract
    end
  end

  describe 'call' do
    let(:mock_contract) do
      double(WorkPackages::CreateNoteContract,
             new: mock_contract_instance)
    end
    let(:mock_contract_instance) do
      double(WorkPackages::CreateNoteContract,
             errors: contract_errors,
             validate: valid_contract)
    end
    let(:valid_contract) { true }
    let(:contract_errors) do
      double('contract errors')
    end

    let(:send_notifications) { false }

    before do
      expect(Journal::NotificationConfiguration)
        .to receive(:with)
        .with(send_notifications)
        .and_yield

      allow(instance).to receive(:contract_class).and_return(mock_contract)
      allow(work_package).to receive(:save_journals).and_return true
    end

    subject { instance.call('blubs', send_notifications: send_notifications) }

    it 'is successful' do
      expect(subject).to be_success
    end

    it 'persists the value' do
      expect(work_package).to receive(:save_journals).and_return true

      subject
    end

    it 'has no errors' do
      expect(subject.errors).to be_empty
    end

    context 'when the contract does not validate' do
      let(:valid_contract) { false }

      it 'is unsuccessful' do
        expect(subject.success?).to be_falsey
      end

      it 'does not persist the changes' do
        expect(work_package).to_not receive(:save_journals)

        subject
      end

      it "exposes the contract's errors" do
        errors = double('errors')
        allow(mock_contract_instance).to receive(:errors).and_return(errors)

        subject

        expect(subject.errors).to eql errors
      end
    end

    context 'when the saving is unsuccessful' do
      before do
        expect(work_package).to receive(:save_journals).and_return false
      end

      it 'is unsuccessful' do
        expect(subject).to_not be_success
      end

      it 'leaves the value unchanged' do
        subject

        expect(work_package.journal_notes).to eql 'blubs'
        expect(work_package.journal_user).to eql user
      end

      it "exposes the work_packages's errors" do
        errors = double('errors')
        allow(work_package).to receive(:errors).and_return(errors)

        subject

        expect(subject.errors).to eql errors
      end
    end
  end
end
