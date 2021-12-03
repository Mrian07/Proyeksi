#-- encoding: UTF-8

module Notifications::CreateFromModelService::WorkPackageStrategy
  def self.reasons
    %i(mentioned assigned responsible watched commented created processed prioritized scheduled)
  end

  def self.permission
    :view_work_packages
  end

  def self.supports_ian?
    true
  end

  def self.supports_mail_digest?
    true
  end

  def self.supports_mail?
    true
  end

  def self.watcher_users(journal)
    User.watcher_recipients(journal.journable)
  end

  def self.project(journal)
    journal.data.project
  end

  def self.user(journal)
    journal.user
  end
end
