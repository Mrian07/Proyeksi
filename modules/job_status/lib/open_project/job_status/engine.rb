#-- encoding: UTF-8



require 'open_project/plugins'

module OpenProject::JobStatus
  class Engine < ::Rails::Engine
    engine_name :openproject_job_status

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-job_status',
             author_url: 'https://www.openproject.org',
             bundled: true

    add_api_endpoint 'API::V3::Root' do
      mount ::API::V3::JobStatus::JobStatusAPI
    end

    add_api_path :job_status do |uuid|
      "#{root}/job_statuses/#{uuid}"
    end

    initializer 'job_status.event_listener' do
      # Extends the ActiveJob adapter in use (DelayedJob) by a Status which lives
      # indenpendently from the job itself (which is deleted once successful or after max attempts).
      # That way, the result of a background job is available even after the original job is gone.
      EventListener.register!
    end

    config.to_prepare do
      # Register the cron job to clear statuses periodically
      ::Cron::CronJob.register! ::JobStatus::Cron::ClearOldJobStatusJob
    end
  end
end
