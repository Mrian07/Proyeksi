#-- encoding: UTF-8



module ProyeksiApp
  module JobStatus
    class EventListener
      class << self
        def register!
          # Listen to enqueues
          ActiveSupport::Notifications.subscribe(/enqueue(_at)?\.active_job/) do |_name, job:, **_args|
            Rails.logger.debug { "Enqueuing background job #{job.inspect}" }
            for_statused_jobs(job) { create_job_status(job) }
          end

          # Start of process
          ActiveSupport::Notifications.subscribe('perform_start.active_job') do |job:, **_args|
            Rails.logger.debug { "Background job #{job.inspect} is being started" }
            for_statused_jobs(job) { on_start(job) }
          end

          # Complete, or failure
          ActiveSupport::Notifications.subscribe('perform.active_job') do |job:, exception_object: nil, **_args|
            Rails.logger.debug do
              successful = exception_object ? "with error #{exception_object}" : "successful"
              "Background job #{job.inspect} was performed #{successful}."
            end

            for_statused_jobs(job) { on_performed(job, exception_object) }
          end

          # Retry stopped -> failure
          ActiveSupport::Notifications.subscribe('retry_stopped.active_job') do |job:, error: nil, **_args|
            Rails.logger.debug { "Background job #{job.inspect} no longer retrying due to: #{error}" }
            for_statused_jobs(job) { on_performed(job, error) }
          end

          # Retry enqueued
          ActiveSupport::Notifications.subscribe('enqueue_retry.active_job') do |job, error: nil, **_args|
            Rails.logger.debug { "Background job #{job.inspect} is being retried after error: #{error}" }
            for_statused_jobs(job) { on_requeue(job, error) }
          end

          # Discarded job
          ActiveSupport::Notifications.subscribe('discard.active_job') do |job:, error: nil, **_args|
            Rails.logger.debug { "Background job #{job.inspect} is being discarded after error: #{error}" }
            for_statused_jobs(job) { on_cancelled(job, error) }
          end
        end

        private

        ##
        # Yiels the block if the job
        # handles statuses
        def for_statused_jobs(job)
          yield if job.respond_to?(:store_status?) && job.store_status?
        end

        ##
        # Create a status object when enqueuing a
        # new job through activejob that stores statuses
        def create_job_status(job)
          job.upsert_status status: :in_queue
        end

        ##
        # On start processing a new job
        def on_start(job)
          job.upsert_status status: :in_process
        end

        ##
        # On requeuing a job after error
        def on_requeue(job, error)
          job.upsert_status status: :in_queue,
                            message: I18n.t('background_jobs.status.error_requeue', message: error)
        end

        ##
        # On cancellation due to the given error
        def on_cancelled(job, error)
          upsert_status job,
                        status: :cancelled,
                        message: I18n.t('background_jobs.status.cancelled_due_to', message: error)
        end

        ##
        # On job performed, handle status updates
        #  - on error, always update
        #  - on success, only update if job doesn't do it itself
        def on_performed(job, exception_object)
          if exception_object
            job.upsert_status status: :failure,
                              message: exception_object.to_s
          elsif !job.updates_own_status?
            job.upsert_status status: :success
          end
        end
      end
    end
  end
end
