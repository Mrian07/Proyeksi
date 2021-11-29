

module Components
  module WorkPackages
    class SortBy
      include Capybara::DSL
      include RSpec::Matchers

      def sort_via_header(name, selector: nil, descending: false)
        text = descending ? 'Sort descending' : 'Sort ascending'

        SeleniumHubWaiter.wait
        open_table_column_context_menu(name, selector)
        SeleniumHubWaiter.wait

        within_column_context_menu do
          click_button text
        end
      end

      def update_criteria(first, second = nil, third = nil)
        open_modal
        SeleniumHubWaiter.wait

        [first, second, third]
          .compact
          .each_with_index do |entry, i|
          column, direction = entry
          update_nth_criteria(i, column, descending: descending?(direction))
        end

        apply_changes
      end

      def expect_criteria(first, second = nil, third = nil)
        open_modal
        SeleniumHubWaiter.wait

        [first, second, third]
          .compact
          .each_with_index do |entry, i|
          column, direction = entry
          page.within(".modal-sorting-row-#{i}") do
            expect(page).to have_selector("#modal-sorting-attribute-#{i} option", text: column)
            checked_radio = (descending?(direction) ? 'Descending' : 'Ascending')
            expect(page.find_field(checked_radio)).to be_checked
          end
        end

        cancel_changes
      end

      def update_nth_criteria(i, column, descending: false)
        page.within(".modal-sorting-row-#{i}") do
          select column, from: "modal-sorting-attribute-#{i}"
          choose(descending ? 'Descending' : 'Ascending')
        end
      end

      def update_sorting_mode(mode)
        if mode === 'manual'
          choose('sorting_mode_switch', option: 'manual')
        else
          choose('sorting_mode_switch', option: 'automatic')
        end
      end

      def open_modal
        modal = TableConfigurationModal.new
        modal.open_and_switch_to 'Sort by'
      end

      def cancel_changes
        page.within('.op-modal') do
          click_on 'Cancel'
        end
      end

      def apply_changes
        page.within('.op-modal') do
          click_on 'Apply'
        end
      end

      private

      def descending?(direction)
        ['desc', 'descending'].include?(direction.to_s)
      end

      def open_table_column_context_menu(name, id)
        id ||= name.downcase
        page.find(".generic-table--sort-header ##{id}").click
      end

      def within_column_context_menu(&block)
        page.within('#column-context-menu', &block)
      end
    end
  end
end
