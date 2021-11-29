#-- encoding: UTF-8



class Mails::WatcherJob < Mails::DeliverJob
  include Mails::WithSender

  def perform(watcher, watcher_changer)
    self.watcher = watcher

    super(watcher.user, watcher_changer)
  end

  def render_mail
    WorkPackageMailer
      .watcher_changed(watcher.watchable,
                       recipient,
                       sender,
                       action)
  end

  private

  attr_accessor :watcher

  def abort?
    super || !notify_about_watcher_changed?
  end

  def notify_about_watcher_changed?
    return false if self_watching?
    return false unless UserMailer.perform_deliveries

    settings = watcher
               .user
               .notification_settings
               .applicable(watcher.watchable.project)
               .first

    settings.watched
  end

  def self_watching?
    watcher.user == sender
  end

  def action
    raise NotImplementedError, 'subclass responsibility'
  end
end
