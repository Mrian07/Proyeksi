

module Components
  module WorkPackages
    class SettingsMenu
      include Capybara::DSL
      include RSpec::Matchers

      def open_and_save_query(name)
        open!
        find("#{selector} .menu-item", text: 'Save', match: :prefer_exact).click
        page.within('.op-modal') do
          find('#save-query-name').set name
          click_on 'Save'
        end
      end

      def open_and_choose(name)
        open!
        choose(name)
      end

      def open!
        click_on 'work-packages-settings-button'
        expect_open
      end

      def expect_open
        expect(page).to have_selector(selector)
      end

      def expect_closed
        expect(page).to have_no_selector(selector)
      end

      def choose(target)
        find("#{selector} .menu-item", text: target).click
      end

      def expect_options(options)
        expect_open
        options.each do |text|
          expect(page).to have_selector("#{selector} a", text: text)
        end
      end

      private

      def selector
        '#settingsDropdown'
      end
    end
  end
end
