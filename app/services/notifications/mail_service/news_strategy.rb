module Notifications::MailService::NewsStrategy
  class << self
    def send_mail(notification)
      return unless notification.journal.initial?

      UserMailer
        .news_added(
          notification.recipient,
          notification.journal.journable
        )
        .deliver_now
    end
  end
end
