#-- encoding: UTF-8



module Notifications::CreateFromModelService::WikiContentStrategy
  def self.reasons
    %i(watched subscribed)
  end

  def self.permission
    :view_wiki_pages
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

  def self.subscribed_notification_reason(journal)
    if journal.initial?
      NotificationSetting::WIKI_PAGE_ADDED
    else
      NotificationSetting::WIKI_PAGE_UPDATED
    end
  end

  def self.watcher_users(journal)
    page = journal.journable.page

    if journal.initial?
      User.watcher_recipients(page.wiki)
    else
      User.watcher_recipients(page.wiki)
          .or(User.watcher_recipients(page))
    end
  end

  def self.project(journal)
    journal.data.project
  end

  def self.user(journal)
    journal.user
  end
end
