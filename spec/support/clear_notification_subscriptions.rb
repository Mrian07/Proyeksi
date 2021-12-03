#-- encoding: UTF-8



RSpec.configure do |config|
  config.after(:each) do |_example|
    ProyeksiApp::Notifications.subscriptions.clear
  end
end
