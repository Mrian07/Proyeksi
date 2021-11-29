

module Pages
  class Page
    include Capybara::DSL
    include RSpec::Matchers
    include OpenProject::StaticRouting::UrlHelpers

    def current_page?
      URI.parse(current_url).path == path
    end

    def visit!
      raise 'No path defined' unless path

      visit path

      self
    end

    def reload!
      page.driver.browser.navigate.refresh
    end

    def accept_alert_dialog!
      alert_dialog.accept if selenium_driver?
    end

    def dismiss_alert_dialog!
      alert_dialog.dismiss if selenium_driver?
    end

    def alert_dialog
      page.driver.browser.switch_to.alert
    end

    def has_alert_dialog?
      if selenium_driver?
        begin
          page.driver.browser.switch_to.alert
        rescue ::Selenium::WebDriver::Error::NoSuchAlertError
          false
        end
      end
    end

    def selenium_driver?
      Capybara.current_session.driver.is_a?(Capybara::Selenium::Driver)
    end

    def set_items_per_page!(n)
      Setting.per_page_options = "#{n}, 50, 100"
    end

    def expect_current_path(query_params = nil)
      uri = URI.parse(current_url)
      current_path = uri.path
      current_path += '?' + uri.query if uri.query

      expected_path = path
      expected_path += "?#{query_params}" if query_params

      expect(current_path).to eql expected_path
    end

    def expect_toast(message:, type: :success)
      if toast_type == :angular
        expect(page).to have_selector(".op-toast.-#{type}", text: message, wait: 20)
      elsif type == :error
        expect(page).to have_selector(".errorExplanation", text: message)
      elsif type == :success
        expect(page).to have_selector(".flash.notice", text: message)
      else
        raise NotImplementedError
      end
    end

    def expect_and_dismiss_toaster(message:, type: :success)
      expect_toast(type: type, message: message)
      dismiss_toaster!
      expect_no_toaster(type: type, message: message)
    end

    def dismiss_toaster!
      if toast_type == :angular
        page.find('.op-toast--close').click
      else
        page.find('.flash .icon-close').click
      end
    end

    def expect_no_toaster(type: :success, message: nil)
      if type.nil?
        expect(page).to have_no_selector(".op-toast")
      else
        expect(page).to have_no_selector(".op-toast.-#{type}", text: message)
      end
    end

    def path
      nil
    end

    def toast_type
      :angular
    end
  end
end
