Rails.application.configure do
  next unless ProyeksiApp::Logging.lograge_enabled?

  config.lograge.enabled = true
  config.lograge.formatter = ProyeksiApp::Logging.formatter
  config.lograge.base_controller_class = %w[ActionController::Base]

  # Add custom data to event payload
  config.lograge.custom_payload do |controller|
    ::ProyeksiApp::Logging.extend_payload!({}, { controller: controller })
  end
end
