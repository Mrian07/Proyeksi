#-- encoding: UTF-8



RSpec.configure do |config|
  config.after(:each) do |_example|
    OpenProject::Notifications.subscriptions.clear
  end
end
