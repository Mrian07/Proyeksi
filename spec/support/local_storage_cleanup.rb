

RSpec.configure do |config|
  config.after(:each, js: true) do
    Capybara.current_session.driver.execute_script('window.localStorage.clear()')
  rescue StandardError
    nil
  end
end
