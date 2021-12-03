

require 'active_job'

class ApplicationJob < ::ActiveJob::Base
  include ::JobStatus::ApplicationJobWithStatus

  ##
  # By default, do not log the arguments of a background job
  # to avoid leaking sensitive information to logs
  self.log_arguments = false

  around_perform :clean_context

  ##
  # Return a priority number on the given payload
  def self.priority_number(prio = :default)
    case prio
    when :high
      0
    when :notification
      5
    when :low
      20
    else
      10
    end
  end

  def self.queue_with_priority(value = :default)
    if value.is_a?(Symbol)
      super priority_number(value)
    else
      super value
    end
  end

  # Resets the thread local request store.
  # This should be done, because normal application code expects the RequestStore to be
  # invalidated between multiple requests and does usually not care whether it is executed
  # from a request or from a delayed job.
  # For a delayed job, each job execution is the thing that comes closest to
  # the concept of a new request.
  def with_clean_request_store
    store = RequestStore.store

    begin
      RequestStore.clear!
      yield
    ensure
      # Reset to previous value
      RequestStore.clear!
      RequestStore.store.merge! store
    end
  end

  # Reloads the thread local ActionMailer configuration.
  # Since the email configuration is now done in the web app, we need to
  # make sure that any changes to the configuration is correctly picked up
  # by the background jobs at runtime.
  def reload_mailer_configuration!
    ProyeksiApp::Configuration.reload_mailer_configuration!
  end

  private

  def clean_context
    with_clean_request_store do
      reload_mailer_configuration!

      yield
    end
  end
end
