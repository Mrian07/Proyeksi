#-- encoding: UTF-8



# Extending Capybara to circumvent problems with selecting the focused element:
# http://opensourcetester.co.uk/2011/07/11/selenium-webdriver-focus/

module Capybara
  class Session
    def has_focus_on?(selector)
      starting_time = Time.now
      return_value = false

      while !return_value && Time.now - starting_time < Capybara.default_max_wait_time

        focused_element = driver.browser.switch_to.active_element

        return_value = find(selector).native == focused_element
      end

      return_value
    end
  end
end
