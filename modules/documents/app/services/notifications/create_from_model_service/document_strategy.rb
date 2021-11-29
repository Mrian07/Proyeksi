#-- encoding: UTF-8



module Notifications::CreateFromModelService::DocumentStrategy
  def self.reasons
    %i(subscribed)
  end

  def self.permission
    :view_documents
  end

  def self.supports_ian?
    false
  end

  def self.supports_mail_digest?
    false
  end

  def self.supports_mail?
    true
  end

  def self.subscribed_users(journal)
    User.notified_globally subscribed_notification_reason(journal)
  end

  def self.subscribed_notification_reason(_journal)
    NotificationSetting::DOCUMENT_ADDED
  end

  def self.project(journal)
    journal.data.project
  end

  def self.user(journal)
    journal.user
  end
end
