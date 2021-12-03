#-- encoding: UTF-8

module Notifications::CreateFromModelService::CommentStrategy
  def self.reasons
    %i(watched subscribed)
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

  def self.subscribed_users(comment)
    User.notified_globally subscribed_notification_reason(comment)
  end

  def self.subscribed_notification_reason(_comment)
    NotificationSetting::NEWS_COMMENTED
  end

  def self.watcher_users(comment)
    User.watcher_recipients(comment.commented)
  end

  def self.project(comment)
    comment.commented.project
  end

  def self.user(comment)
    comment.author
  end
end
