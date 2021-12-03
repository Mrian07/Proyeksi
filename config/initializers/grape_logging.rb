ProyeksiApp::Application.configure do
  config.after_initialize do
    ActiveSupport::Notifications.subscribe('proyeksiapp_grape_logger') do |_, _, _, _, payload|
      time = payload[:time]
      attributes = {
        duration: time[:total],
        db: time[:db],
        view: time[:view]
      }.merge(payload.except(:time))

      extended = ProyeksiApp::Logging.extend_payload!(attributes, {})
      Rails.logger.info ProyeksiApp::Logging.formatter.call(extended)
    end
  end
end
