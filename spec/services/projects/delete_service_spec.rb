

require 'spec_helper'

describe ::Projects::DeleteService, type: :model do
  let(:user) { FactoryBot.build_stubbed(:admin) }
  let(:project) { FactoryBot.build_stubbed(:project) }

  let(:instance) { described_class.new(user: user, model: project) }

  subject { instance.call }

  context 'if authorized' do
    it 'destroys the project and sends a success mail' do
      expect(project).not_to receive(:archive)
      expect(project).to receive(:destroy).and_return true

      expect(ProjectMailer)
        .to receive_message_chain(:delete_project_completed, :deliver_now)

      expect(::Projects::DeleteProjectJob)
        .not_to receive(:new)

      expect(subject).to be_success
    end

    it 'sends a message on destroy failure' do
      expect(project).to receive(:destroy).and_return false

      expect(ProjectMailer)
        .to receive_message_chain(:delete_project_failed, :deliver_now)

      expect(::Projects::DeleteProjectJob)
        .not_to receive(:new)

      expect(subject).to be_failure
    end
  end

  context 'if not authorized' do
    let(:user) { FactoryBot.build_stubbed(:user) }

    it 'returns an error' do
      expect(::Projects::DeleteProjectJob)
        .not_to receive(:new)

      expect(subject).to be_failure
    end
  end
end
