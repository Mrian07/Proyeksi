

require 'spec_helper'

describe Notifications::Scopes::MailReminderUnsent, type: :model do
  describe '.unread_digest_mail' do
    subject(:scope) { ::Notification.mail_reminder_unsent }

    let(:no_mail_notification) { FactoryBot.create(:notification, mail_reminder_sent: nil) }
    let(:unread_mail_notification) { FactoryBot.create(:notification, mail_reminder_sent: false) }
    let(:read_mail_notification) { FactoryBot.create(:notification, mail_reminder_sent: true) }

    before do
      no_mail_notification
      unread_mail_notification
      read_mail_notification
    end

    it 'contains the notifications with read_mail: false' do
      expect(scope)
        .to match_array([unread_mail_notification])
    end
  end
end
