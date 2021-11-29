

module Components
  module UIAutocompleteHelpers
    def search_autocomplete(element, query:, results_selector: nil)
      # Open the element
      element.click
      # Insert the text to find
      element.set(query)
      sleep(0.5)

      ##
      # Find the open dropdown
      list =
        if results_selector
          page.find(results_selector)
        else
          page.find('.ui-autocomplete')
        end

      scroll_to_element(list)
      list
    end

    def select_autocomplete(element, query:, results_selector: nil, item_selector: nil, select_text: nil)
      target_dropdown = search_autocomplete(element, results_selector: results_selector, query: query)

      ##
      # If a specific select_text is given, use that to locate the match,
      # otherwise use the query
      text = select_text.presence || query

      # click the element to select it
      query_element = if item_selector
                        target_dropdown.find(item_selector, text: text)
                      else
                        target_dropdown.find('.ui-menu-item', text: text)
                      end
      query_element.click
    end
  end
end

shared_context 'ui-autocomplete helpers' do
  include ::Components::UIAutocompleteHelpers
end
