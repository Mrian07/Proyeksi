

require 'spec_helper'

describe Notifications::Scopes::UnsentRemindersBefore, type: :model do
  describe '.unsent_reminders_before' do
    subject(:scope) { ::Notification.unsent_reminders_before(recipient: recipient, time: time) }

    let(:recipient) do
      FactoryBot.create(:user)
    end
    let(:time) do
      Time.current
    end

    let(:notification) do
      FactoryBot.create(:notification,
                        recipient: notification_recipient,
                        read_ian: notification_read_ian,
                        mail_reminder_sent: notification_mail_reminder_sent,
                        created_at: notification_created_at)
    end
    let(:notification_mail_reminder_sent) { false }
    let(:notification_read_ian) { false }
    let(:notification_created_at) { Time.current - 10.minutes }
    let(:notification_recipient) { recipient }

    let!(:notifications) { notification }

    shared_examples_for 'is empty' do
      it 'is empty' do
        expect(scope)
          .to be_empty
      end
    end

    context 'with a unread and not reminded notification that was created before the time and for the user' do
      it 'returns the notification' do
        expect(scope)
          .to match_array([notification])
      end
    end

    context 'with a unread and not reminded notification that was created after the time and for the user' do
      let(:notification_created_at) { Time.current + 10.minutes }

      it_behaves_like 'is empty'
    end

    context 'with a unread and not reminded notification that was created before the time and for different user' do
      let(:notification_recipient) { FactoryBot.create(:user) }

      it_behaves_like 'is empty'
    end

    context 'with a unread and not reminded notification created before the time and for the user' do
      let(:notification_mail_reminder_sent) { nil }

      it_behaves_like 'is empty'
    end

    context 'with a unread but reminded notification created before the time and for the user' do
      let(:notification_mail_reminder_sent) { true }

      it_behaves_like 'is empty'
    end

    context 'with a read notification that was created before the time' do
      let(:notification_read_ian) { true }

      it_behaves_like 'is empty'
    end
  end
end
