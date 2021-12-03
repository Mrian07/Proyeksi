module Notifications::MailService::CommentStrategy
  class << self
    def send_mail(notification)
      UserMailer
        .news_comment_added(
          notification.recipient,
          notification.resource
        )
        .deliver_now
    end
  end
end
