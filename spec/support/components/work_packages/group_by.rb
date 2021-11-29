

module Components
  module WorkPackages
    class GroupBy
      include Capybara::DSL
      include RSpec::Matchers

      def enable_via_header(name)
        open_table_column_context_menu(name)

        within_column_context_menu do
          click_button('Group by')
        end
      end

      def enable_via_menu(name)
        modal = TableConfigurationModal.new

        modal.open_and_set_display_mode 'grouped'
        select name, from: 'selected_grouping'
        modal.save
      end

      def disable_via_menu
        modal = TableConfigurationModal.new
        modal.open_and_set_display_mode 'default'
        modal.save
      end

      def expect_number_of_groups(count)
        expect(page).to have_selector('[data-qa-selector="op-group--value"] .count', count: count)
      end

      def expect_grouped_by_value(value_name, count)
        expect(page).to have_selector('[data-qa-selector="op-group--value"]', text: "#{value_name} (#{count})")
      end

      def expect_no_groups
        expect(page).to have_no_selector('[data-qa-selector="op-group--value"]')
      end

      def expect_not_grouped_by(name)
        open_table_column_context_menu(name)

        within_column_context_menu do
          expect(page).to have_content('Group by')
        end
      end

      private

      def open_table_column_context_menu(name)
        page.find(".generic-table--sort-header ##{name.downcase}").click
      end

      def within_column_context_menu(&block)
        page.within('#column-context-menu', &block)
      end
    end
  end
end
