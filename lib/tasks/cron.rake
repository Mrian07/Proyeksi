namespace 'openproject:cron' do
  desc 'An hourly cron job hook for plugin functionality'
  task :hourly do
    # Does nothing by default
  end

  desc 'Ensure the cron-like background jobs are actively scheduled'
  task schedule: [:environment] do
    ::Cron::CronJob.schedule_registered_jobs!
  end
end
