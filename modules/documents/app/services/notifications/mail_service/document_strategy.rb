

module Notifications::MailService::DocumentStrategy
  class << self
    def send_mail(notification)
      return unless notification.journal.initial?

      DocumentsMailer
        .document_added(
          notification.recipient,
          notification.resource
        )
        .deliver_later
    end
  end
end
