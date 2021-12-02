# Register "Cron-like jobs"

ProyeksiApp::Application.configure do |application|
  application.config.to_prepare do
    ::Cron::CronJob.register! ::Cron::ClearOldSessionsJob,
                              ::Cron::ClearTmpCacheJob,
                              ::Cron::ClearUploadedFilesJob,
                              ::OAuth::CleanupJob,
                              ::Attachments::CleanupUncontaineredJob,
                              ::Notifications::ScheduleReminderMailsJob
  end
end
