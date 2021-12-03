module Notifications::MailService::MessageStrategy
  class << self
    def send_mail(notification)
      UserMailer
        .message_posted(
          notification.recipient,
          notification.resource
        )
        .deliver_now
    end
  end
end
