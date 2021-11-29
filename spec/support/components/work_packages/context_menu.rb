

module Components
  module WorkPackages
    class ContextMenu
      include Capybara::DSL
      include RSpec::Matchers

      def open_for(work_package)
        # Close
        find('body').send_keys :escape
        sleep 0.5

        if page.has_selector?('#wp-view-toggle-button', text: 'Cards')
          page.find(".op-wp-single-card-#{work_package.id}").right_click
        else
          page.find(".wp-row-#{work_package.id}-table").right_click
        end

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

      def expect_no_options(*options)
        expect_open
        options.each do |text|
          expect(page).to have_no_selector("#{selector} .menu-item", text: text)
        end
      end

      def expect_options(options)
        expect_open
        options.each do |text|
          expect(page).to have_selector("#{selector} .menu-item", text: text)
        end
      end

      private

      def selector
        '#work-package-context-menu'
      end
    end
  end
end
