#-- encoding: UTF-8



module Notifications::Scopes
  module UnsentRemindersBefore
    extend ActiveSupport::Concern

    class_methods do
      # Return notifications for the user for who email reminders shall be sent and that were created before
      # the specified time.
      def unsent_reminders_before(recipient:, time:)
        where(Notification.arel_table[:created_at].lteq(time))
          .where(recipient: recipient)
          .where("read_ian IS NULL OR read_ian IS FALSE")
          .where(mail_reminder_sent: false)
      end
    end
  end
end
