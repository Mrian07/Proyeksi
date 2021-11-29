

module Components
  module WorkPackages
    class DisplayRepresentation
      include Capybara::DSL
      include RSpec::Matchers

      def initialize; end

      def switch_to_card_layout
        expect_button 'Card'
        select_view 'Card'
      end

      def switch_to_list_layout
        expect_button 'Table'
        select_view 'Table'
      end

      def switch_to_gantt_layout
        expect_button 'Gantt'
        select_view 'Gantt'
      end

      def expect_state(text)
        expect(page).to have_selector('#wp-view-toggle-button', text: text, wait: 10)
      end

      private

      def expect_button(forbidden_text)
        expect(page).to have_button('wp-view-toggle-button', disabled: false)
        expect(page).to have_no_selector('#wp-view-toggle-button', text: forbidden_text)
      end

      def select_view(view_name)
        page.find('wp-view-toggle-button').click

        within_view_context_menu do
          click_button(view_name)
        end
      end

      def within_view_context_menu(&block)
        page.within('#wp-view-context-menu', &block)
      end
    end
  end
end
