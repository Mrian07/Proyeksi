

require 'spec_helper'

describe ::Projects::ScheduleDeletionService, type: :model do
  let(:contract_class) do
    contract = double('contract_class', '<=': true)

    allow(contract)
      .to receive(:new)
      .with(project, user, options: {})
      .and_return(contract_instance)

    contract
  end
  let(:contract_instance) do
    double('contract_instance', validate: contract_valid, errors: contract_errors)
  end
  let(:contract_valid) { true }
  let(:contract_errors) do
    double('contract_errors')
  end
  let(:project_valid) { true }
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:instance) do
    described_class.new(user: user,
                        model: project,
                        contract_class: contract_class)
  end
  let(:archive_success) do
    true
  end
  let(:archive_errors) do
    double('archive_errors')
  end
  let(:archive_result) do
    ServiceResult.new result: project,
                      success: archive_success,
                      errors: archive_errors
  end
  let!(:archive_service) do
    service = double('archive_service_instance')

    allow(Projects::ArchiveService)
      .to receive(:new)
      .with(user: user,
            model: project)
      .and_return(service)

    allow(service)
      .to receive(:call)
      .and_return(archive_result)

    service
  end
  let(:user) { FactoryBot.build_stubbed(:admin) }

  subject { instance.call }

  context 'if contract and archiving are successful' do
    it 'archives the project and creates a delayed job' do
      expect(archive_service)
        .to receive(:call)
        .and_return(archive_result)

      expect(::Projects::DeleteProjectJob)
        .to receive(:perform_later)
        .with(user: user, project: project)

      expect(subject).to be_success
    end
  end

  context 'if contract fails' do
    let(:contract_valid) { false }

    it 'is failure' do
      expect(subject).to be_failure
    end

    it 'returns the contract errors' do
      expect(subject.errors)
        .to eql contract_errors
    end

    it 'does not schedule a job' do
      expect(::Projects::DeleteProjectJob)
        .not_to receive(:new)

      subject
    end
  end

  context 'if archiving fails' do
    let(:archive_success) { false }

    it 'is failure' do
      expect(subject).to be_failure
    end

    it 'returns the contract errors' do
      expect(subject.errors)
        .to eql archive_errors
    end

    it 'does not schedule a job' do
      expect(::Projects::DeleteProjectJob)
        .not_to receive(:new)

      subject
    end
  end
end
