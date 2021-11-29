

require 'features/support/components/ui_autocomplete'

module Components
  module Projects
    class TopMenu
      include Capybara::DSL
      include RSpec::Matchers
      include ::Components::UIAutocompleteHelpers

      def toggle
        page.find('#projects-menu').click
      end

      def expect_current_project(name)
        expect(page).to have_selector('#projects-menu', text: name)
      end

      def expect_open
        expect(page).to have_selector(autocompleter_selector)
      end

      def expect_closed
        expect(page).to have_no_selector(autocompleter_selector)
      end

      def search(query)
        search_autocomplete(autocompleter, query: query)
      end

      def clear_search
        autocompleter.set ''
        autocompleter.send_keys :backspace
      end

      def search_and_select(query)
        select_autocomplete autocompleter,
                            results_selector: autocompleter_results_selector,
                            query: query
      end

      def search_results
        page.find autocompleter_results_selector
      end

      def autocompleter
        page.find autocompleter_selector
      end

      def autocompleter_results_selector
        '.project-menu-autocomplete--results'
      end

      def autocompleter_selector
        '#project_autocompletion_input'
      end
    end
  end
end
