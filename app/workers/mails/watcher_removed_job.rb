#-- encoding: UTF-8

class Mails::WatcherRemovedJob < Mails::WatcherJob
  def perform(watcher_attributes, watcher_changer)
    watcher = Watcher.new(watcher_attributes)

    super(watcher, watcher_changer)
  end

  private

  def action
    'removed'
  end
end
