#-- encoding: UTF-8



if defined?(Bullet) && Rails.env.development?
  ProyeksiApp::Application.configure do
    config.after_initialize do
      Bullet.enable = true
      # Bullet.alert = true
      Bullet.bullet_logger = true if File.directory?('log') # fails if run from an engine
      Bullet.console = true
      # Bullet.growl = true
      Bullet.rails_logger = true
    end
  end
end
