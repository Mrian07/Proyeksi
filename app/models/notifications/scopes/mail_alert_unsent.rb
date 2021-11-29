#-- encoding: UTF-8



# Return alert mail notifications that are unread (have mail_alert_sent: false)
module Notifications::Scopes
  module MailAlertUnsent
    extend ActiveSupport::Concern

    class_methods do
      def mail_alert_unsent
        where(mail_alert_sent: false)
      end
    end
  end
end
