

require 'features/support/components/ui_autocomplete'

module Components
  module WorkPackages
    class QueryMenu
      include Capybara::DSL
      include RSpec::Matchers
      include ::Components::UIAutocompleteHelpers

      def select(query)
        select_autocomplete autocompleter,
                            results_selector: autocompleter_results_selector,
                            item_selector: autocompleter_item_selector,
                            query: query
      end

      def autocompleter
        page.find autocompleter_selector
      end

      def autocompleter_results_selector
        '.op-query-select--search-results'
      end

      def autocompleter_item_selector
        '.op-sidemenu--item-action'
      end

      def autocompleter_selector
        '#query-title-filter'
      end
    end
  end
end
