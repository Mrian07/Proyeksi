

airbrake = OpenProject::Configuration['airbrake']

if airbrake && airbrake['api_key']
  # airbrake isn't loaded by default, so let's do that now
  require 'airbrake'

  Airbrake.configure do |config|
    config.api_key = airbrake['api_key']
    config.host = airbrake['host'] if airbrake['host']
    config.port = Integer(airbrake['port'] || 443)
    config.secure = config.port == 443

    Rails.logger.info "Successfully connected to Airbrake at #{config.host}:#{config.port}."
  end
end
