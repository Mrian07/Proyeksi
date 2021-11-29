#-- encoding: UTF-8



module Cron
  class CronJob < ApplicationJob
    class_attribute :cron_expression

    # List of registered jobs, requires eager load in dev(!)
    class_attribute :registered_jobs, default: []

    class << self
      ##
      # Register new job class(es)
      def register!(*job_classes)
        Array(job_classes).each do |clz|
          raise ArgumentError, "Needs to be subclass of ::Cron::CronJob" unless clz.ancestors.include?(self)

          registered_jobs << clz
        end
      end

      def schedule_registered_jobs!
        registered_jobs.each do |job_class|
          job_class.ensure_scheduled!
        end
      end

      ##
      # Ensure the job is scheduled unless it is already
      def ensure_scheduled!
        # Ensure scheduled only once
        return if scheduled?

        Rails.logger.info { "Scheduling #{name} recurrent background job." }
        set(cron: cron_expression).perform_later
      end

      ##
      # Remove the scheduled job, if any
      def remove
        delayed_job&.destroy
      end

      ##
      # Is there a job scheduled?
      def scheduled?
        delayed_job_query.exists?
      end

      def delayed_job
        delayed_job_query.first
      end

      def delayed_job_query
        Delayed::Job.where('handler LIKE ?', "%job_class: #{name}%")
      end
    end
  end
end
