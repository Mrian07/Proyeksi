#-- encoding: UTF-8



# Return digest mail notifications that are unread (have read_digest_mail: false)
module Notifications::Scopes
  module MailReminderUnsent
    extend ActiveSupport::Concern

    class_methods do
      def mail_reminder_unsent
        where(mail_reminder_sent: false)
      end
    end
  end
end
