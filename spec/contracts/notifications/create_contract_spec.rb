

require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe Notifications::CreateContract do
  include_context 'ModelContract shared context'

  let(:current_user) do
    FactoryBot.build_stubbed(:user) do |user|
    end
  end

  let(:notification_context) { FactoryBot.build_stubbed(:project) }
  let(:notification_resource) { FactoryBot.build_stubbed(:journal) }
  let(:notification_recipient) { FactoryBot.build_stubbed(:user) }
  let(:notification_subject) { 'Some text' }
  let(:notification_reason) { :mentioned }
  let(:notification_read_ian) { false }
  let(:notification_mail_reminder_sent) { false }

  let(:notification) do
    Notification.new(project: notification_context,
                     recipient: notification_recipient,
                     subject: notification_subject,
                     reason: notification_reason,
                     resource: notification_resource,
                     read_ian: notification_read_ian,
                     mail_reminder_sent: notification_mail_reminder_sent)
  end

  let(:contract) { described_class.new(notification, current_user) }

  describe '#validation' do
    it_behaves_like 'contract is valid'

    context 'without a recipient' do
      let(:notification_recipient) { nil }

      it_behaves_like 'contract is invalid', recipient: :blank
    end

    context 'without a reason' do
      let(:notification_reason) { nil }

      it_behaves_like 'contract is invalid', reason: :no_notification_reason
    end

    context 'without a subject' do
      let(:notification_subject) { nil }

      it_behaves_like 'contract is valid'
    end

    context 'with an empty subject' do
      let(:notification_subject) { '' }

      it_behaves_like 'contract is valid'
    end

    context 'with read_ian true' do
      let(:notification_read_ian) { true }

      it_behaves_like 'contract is invalid', read_ian: :read_on_creation
    end

    context 'with mail_reminder_sent true' do
      let(:notification_mail_reminder_sent) { true }

      it_behaves_like 'contract is invalid', mail_reminder_sent: :set_on_creation
    end
  end
end
