# Use rack-timeout if we run in clustered mode with at least 2 workers
# so that workers, should a timeout occur, can be restarted without interruption.
if ProyeksiApp::Configuration.web_workers >= 2
  timeout = Integer(ENV['RACK_TIMEOUT_SERVICE_TIMEOUT'].presence || ProyeksiApp::Configuration.web_timeout)
  wait_timeout = Integer(ENV['RACK_TIMEOUT_WAIT_TIMEOUT'].presence || ProyeksiApp::Configuration.web_wait_timeout)

  Rails.logger.debug { "Enabling Rack::Timeout (service=#{timeout}s wait=#{wait_timeout}s)" }

  Rails.application.config.middleware.insert_before(
    ::Rack::Runtime,
    ::Rack::Timeout,
    service_timeout: timeout, # time after which a request being served times out
    wait_timeout: wait_timeout, # time after which a request waiting to be served times out
    term_on_timeout: 1 # shut down worker (gracefully) right away on timeout to be restarted
  )

  # remove default logger (logging uninteresting extra info with each not timed out request)
  Rack::Timeout.unregister_state_change_observer(:logger)

  Rack::Timeout.register_state_change_observer(:wait_timeout_logger) do |env|
    details = env[Rack::Timeout::ENV_INFO_KEY]

    if details.state == :timed_out && details.wait.present?
      ::ProyeksiApp.logger.error "Request timed out waiting to be served!"
    end
  end

  # The timeout itself is already reported so no need to
  # report the generic internal server error too as it doesn't
  # add any more information. Even worse, it's not immediately
  # clear that the two reports are related.
  module SuppressInternalErrorReportOnTimeout
    def op_handle_error(message_or_exception, context = {})
      return if request && request.env[Rack::Timeout::ENV_INFO_KEY].try(:state) == :timed_out

      super
    end
  end

  ProyeksiAppErrorHelper.prepend SuppressInternalErrorReportOnTimeout
else
  Rails.logger.debug { "Not enabling Rack::Timeout since we are not running in cluster mode with at least 2 workers" }
end
