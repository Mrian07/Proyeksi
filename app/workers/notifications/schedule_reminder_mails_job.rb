

module Notifications
  class ScheduleReminderMailsJob < Cron::CronJob
    # runs every quarter of an hour, so 00:00, 00:15...
    self.cron_expression = '*/15 * * * *'

    def perform
      User.having_reminder_mail_to_send(run_at).pluck(:id).each do |user_id|
        Mails::ReminderJob.perform_later(user_id)
      end
    end

    def run_at
      self.class.delayed_job.run_at
    end
  end
end
