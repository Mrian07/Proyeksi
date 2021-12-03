if ProyeksiApp::Logging::SentryLogger.enabled?
  require "sentry-ruby"
  require "sentry-rails"
  require "sentry-delayed_job"

  # Explicitly require the send event job
  require File.join(Sentry::Engine.root, 'app/jobs/sentry/send_event_job')

  # We need to manually load the sentry initializer
  # as we're dynamically loading it
  # https://github.com/getsentry/sentry-ruby/blob/master/sentry-rails/lib/sentry/rails/railtie.rb#L8-L13
  ProyeksiApp::Application.configure do |app|
    # need to be placed at last to smuggle app exceptions via env
    app.config.middleware.use(Sentry::Rails::RescuedExceptionInterceptor)
  end

  ##
  # Define the SentryJob here, as sentry gets dynamically loaded
  class SentryJob < Sentry::SendEventJob
    queue_with_priority :low
  end

  Sentry.init do |config|
    config.dsn = ProyeksiApp::Logging::SentryLogger.sentry_dsn
    config.breadcrumbs_logger = ProyeksiApp::Configuration.sentry_breadcrumb_loggers.map(&:to_sym)

    # Submit events as delayed job only when requested to do that
    if ENV['PROYEKSIAPP_SENTRY_DELAYED_JOB'] == 'true'
      config.async = lambda do |event, hint|
        ::SentryJob.perform_later(event, hint)
      end
    end

    # Output debug info for sentry
    config.before_send = lambda do |event, hint|
      Rails.logger.debug do
        payload_sizes = event.to_json_compatible.transform_values { |v| JSON.generate(v).bytesize }.inspect
        "[Sentry] will send event #{hint}. Payload sizes are #{payload_sizes.inspect}"
      end

      event
    end

    # Don't send loaded modules
    config.send_modules = false

    # Cleanup backtrace
    config.backtrace_cleanup_callback = lambda do |backtrace|
      Rails.backtrace_cleaner.clean(backtrace)
    end

    # Sample rate for performance
    # 0.0 = disabled
    # 1.0 = all samples are traced
    sample_factor = ProyeksiApp::Configuration.sentry_trace_factor.to_f

    # Define a tracing sample handler
    trace_sampler = lambda do |sampling_context|
      # if this is the continuation of a trace, just use that decision (rate controlled by the caller)
      next sampling_context[:parent_sampled] unless sampling_context[:parent_sampled].nil?

      # transaction_context is the transaction object in hash form
      # keep in mind that sampling happens right after the transaction is initialized
      # for example, at the beginning of the request
      transaction_context = sampling_context[:transaction_context]

      # transaction_context helps you sample transactions with more sophistication
      # for example, you can provide different sample rates based on the operation or name
      op = transaction_context[:op]
      transaction_name = transaction_context[:name]

      rate = case op
             when /request/
               case transaction_name
               when /health_check/
                 0.0
               else
                 [0.1 * sample_factor, 1.0].min
               end
             when /delayed_job/
               [0.01 * sample_factor, 1.0].min
             else
               0.0 # ignore all other transactions
             end

      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Decided on sampling rate #{rate} for #{op}: #{transaction_name} " }

      rate
    end

    # Assign the sampler conditionally to avoid running the lambda
    # when we don't trace anyway
    if sample_factor.zero?
      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Requested factor is zero, skipping performance tracing" }
      config.traces_sample_rate = 0
      config.traces_sampler = nil
    else
      Rails.logger.debug { "[SENTRY TRACE SAMPLER] Requested factor is #{sample_factor}, setting up performance tracing" }
      config.traces_sampler = trace_sampler
    end

    # Set release info
    config.release = ProyeksiApp::VERSION.to_s
  end

  # Extend the core log delegator
  handler = ::ProyeksiApp::Logging::SentryLogger.method(:log)
  ::ProyeksiApp::Logging::LogDelegator.register(:sentry, handler)
end
