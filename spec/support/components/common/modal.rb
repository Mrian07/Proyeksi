

module Components
  module Common
    class Modal
      include Capybara::DSL
      include RSpec::Matchers

      def initialize; end

      def expect_title(text)
        within_modal do
          expect(page).to have_selector('.op-modal--title' ,text: text)
        end
      end

      def expect_open
        expect(page).to have_selector(selector, wait: 40)
      end

      def expect_closed
        expect(page).to have_no_selector(selector)
      end

      def expect_text(text)
        within_modal do
          expect(page).to have_text(text)
        end
      end

      def click_modal_button(text)
        within_modal do
          click_button text
        end
      end

      def within_modal(&block)
        page.within(selector, &block)
      end

      def modal_element
        page.find(selector)
      end

      def selector
        '.op-modal'
      end
    end
  end
end
