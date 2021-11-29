

module Components
  class PasswordConfirmationDialog
    include Capybara::DSL
    include RSpec::Matchers

    def initialize; end

    def confirm_flow_with(password, should_fail: false)
      expect_open

      expect(submit_button).to be_disabled
      fill_in 'request_for_confirmation_password', with: password

      expect(submit_button).not_to be_disabled
      submit(should_fail)
    end

    def expect_open
      expect(page).to have_selector(selector)
    end

    def expect_closed
      expect(page).to have_no_selector(selector)
    end

    def submit_button
      page.find('.confirm-form-submit--continue')
    end

    private

    def selector
      '.password-confirm-dialog--modal'
    end

    def submit(should_fail)
      submit_button.click

      if should_fail
        expect(page).to have_selector('.flash.error',
                                      text: I18n.t(:notice_password_confirmation_failed))
      else
        expect(page).to have_no_selector('.flash.error')
      end
    end
  end
end
