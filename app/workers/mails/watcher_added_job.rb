#-- encoding: UTF-8

class Mails::WatcherAddedJob < Mails::WatcherJob
  private

  def action
    'added'
  end
end
