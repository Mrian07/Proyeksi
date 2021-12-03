#-- encoding: UTF-8

module Notifications
  class CleanupJob < ::Cron::CronJob
    DEFAULT_RETENTION ||= 30

    # runs at 2:22 nightly
    self.cron_expression = '22 2 * * *'

    def perform
      Notification
        .where('updated_at < ?', oldest_notification_retention_time)
        .delete_all
    end

    private

    def oldest_notification_retention_time
      days_ago = Setting.notification_retention_period_days.to_i
      days_ago = DEFAULT_RETENTION if days_ago <= 0

      Time.zone.today - days_ago.days
    end
  end
end
