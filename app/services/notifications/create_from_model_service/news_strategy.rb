#-- encoding: UTF-8



module Notifications::CreateFromModelService::NewsStrategy
  def self.reasons
    %i(subscribed)
  end

  def self.permission
    :view_news
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
    if journal.initial?
      User.notified_globally subscribed_notification_reason(journal)
    else
      # No notification on updating a news
      User.none
    end
  end

  def self.subscribed_notification_reason(_journal)
    NotificationSetting::NEWS_ADDED
  end

  def self.project(journal)
    journal.data.project
  end

  def self.user(journal)
    journal.user
  end
end
