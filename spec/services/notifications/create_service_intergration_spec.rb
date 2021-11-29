

require 'spec_helper'

describe Notifications::CreateService, 'integration', type: :model do
  let(:work_package) { FactoryBot.create(:work_package) }
  let(:project) { work_package.project }
  let(:journal) { work_package.journals.first }
  let(:instance) { described_class.new(user: actor) }
  let(:attributes) { {} }
  let(:actor) { current_user }
  let(:recipient) { FactoryBot.create(:user) }
  let(:service_result) do
    instance
      .call(**attributes)
  end

  current_user { FactoryBot.create(:user) }

  describe '#call' do
    let(:attributes) do
      {
        recipient: recipient,
        project: project,
        resource: work_package,
        journal: journal,
        actor: actor,
        read_ian: false,
        reason: :mentioned,
        mail_reminder_sent: nil,
        mail_alert_sent: nil
      }
    end

    it 'creates a notification' do
      # successful
      expect { service_result }
        .to change(Notification, :count)
              .by(1)

      expect(service_result)
        .to be_success
    end

    context 'with the journal being deleted in the meantime (e.g. via a different process)' do
      before do
        Journal.where(id: journal.id).delete_all
      end

      it 'creates no notification' do
        # successful
        expect { service_result }
          .not_to change(Notification, :count)

        expect(service_result)
          .to be_failure

        expect(service_result.errors.details[:journal_id])
          .to match_array [{ error: :does_not_exist }]
      end
    end
  end
end
