

module Notifications::MailService::WikiContentStrategy
  class << self
    def send_mail(notification)
      method = mailer_method(notification)

      UserMailer
        .send(method,
              notification.recipient,
              notification.journal.journable)
        .deliver_now
    end

    private

    def mailer_method(notification)
      if notification.journal.initial?
        :wiki_content_added
      else
        :wiki_content_updated
      end
    end
  end
end
