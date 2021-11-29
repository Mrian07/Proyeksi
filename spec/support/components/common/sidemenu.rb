

module Components
  module Notifications
    class Sidemenu
      include Capybara::DSL
      include RSpec::Matchers

      def initialize; end

      def expect_open
        expect(page).to have_selector('[data-qa-selector="op-sidemenu"]')
      end

      def expect_item_not_visible(item)
        expect(page).to have_no_selector(item_selector, text: item)
      end

      def expect_item_with_count(item, count)
        within item_action_selector(item) do
          expect(page).to have_text item
          expect_count(count)
        end
      end

      def expect_item_with_no_count(item)
        within item_action_selector(item) do
          expect(page).to have_text item
          expect_no_count
        end
      end

      def click_item(item)
        page.find(item_action_selector(item), text: item).click
      end

      def finished_loading
        expect(page).to have_no_selector('.op-ian-center--loading-indicator')
      end

      private

      def expect_count(count)
        expect(page).to have_selector('.op-bubble', text: count)
      end

      def expect_no_count
        expect(page).to have_no_selector('.op-bubble')
      end

      def item_action_selector(item)
        "[data-qa-selector='op-sidemenu--item-action--#{item.delete(' ')}']"
      end

      def item_selector
        '[data-qa-selector="op-sidemenu--item"]'
      end
    end
  end
end
