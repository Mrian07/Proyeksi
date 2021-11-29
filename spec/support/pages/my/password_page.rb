

require 'support/pages/page'

module Pages
  module My
    class PasswordPage < ::Pages::Page
      def path
        '/my/password'
      end

      def change_password(old_password, new_password, confirmation = new_password)
        SeleniumHubWaiter.wait
        page.fill_in('password', with: old_password, match: :prefer_exact)
        page.fill_in('new_password', with: new_password)
        page.fill_in('new_password_confirmation', with: confirmation)

        page.click_link_or_button 'Save'
      end

      def expect_password_reuse_error_message(count)
        expect_toast(type: :error,
                            message: I18n.t(:'activerecord.errors.models.user.attributes.password.reused', count: count))
      end

      def expect_password_weak_error_message
        expect_toast(type: :error,
                            message: "Password Must contain characters of the following classes (at least 2 of 3): lowercase (e.g. 'a'), uppercase (e.g. 'A'), numeric (e.g. '1').")
      end

      def expect_password_updated_message
        expect(page)
          .to have_selector('.flash.notice', text: I18n.t(:notice_account_password_updated))
      end

      private

      def toast_type
        :rails
      end
    end
  end
end
