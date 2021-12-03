#-- encoding: UTF-8

class Exports::CleanupOutdatedJob < ApplicationJob
  queue_with_priority :low

  def self.perform_after_grace
    set(wait: ProyeksiApp::Configuration.attachments_grace_period.minutes).perform_later
  end

  def perform
    Export
      .where('created_at <= ?', Time.current - ProyeksiApp::Configuration.attachments_grace_period.minutes)
      .destroy_all
  end
end
