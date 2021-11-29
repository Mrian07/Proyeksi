

module Notifications::MailService::WorkPackageStrategy
  class << self
    def send_mail(notification)
      return unless notification.reason_mentioned?
      return unless notification.recipient.pref.immediate_reminders[:mentioned]

      WorkPackageMailer
        .mentioned(notification.recipient, notification.journal)
        .deliver_later
    end
  end
end
