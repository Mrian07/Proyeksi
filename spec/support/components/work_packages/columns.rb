

require_relative '../ng_select_autocomplete_helpers'

module Components
  module WorkPackages
    class Columns
      include Capybara::DSL
      include RSpec::Matchers
      include ::Components::NgSelectAutocompleteHelpers

      attr_accessor :trigger_parent

      def initialize(trigger_parent = nil)
        self.trigger_parent = trigger_parent
      end

      def column_autocompleter
        find('.columns-modal--content .op-draggable-autocomplete--input')
      end

      def close_autocompleter
        find('.columns-modal--content .op-draggable-autocomplete--input input').send_keys :escape
      end

      def column_item(name)
        find('.op-draggable-autocomplete--item', text: name)
      end

      def expect_column_not_available(name)
        modal_open? or open_modal

        column_autocompleter.click
        expect(page).to have_no_selector('.ng-option', text: name, visible: :all)
        close_autocompleter
      end

      def expect_column_available(name)
        modal_open? or open_modal

        column_autocompleter.click
        expect(page).to have_selector('.ng-option', text: name, visible: :all)
        close_autocompleter
      end

      def add(name, save_changes: true, finicky: false)
        modal_open? or open_modal

        select_autocomplete column_autocompleter,
                            results_selector: '.ng-dropdown-panel-items',
                            query: name

        if save_changes
          apply
          within ".work-package-table" do
            # for some reason these columns (e.g. 'Overall costs') don't have a proper link
            if finicky
              SeleniumHubWaiter.wait
              expect(page).to have_selector("a", text: /#{name}/i, visible: :all)
            else
              expect(page).to have_link(name)
            end
          end
        end
      end

      def remove(name, save_changes: true)
        modal_open? or open_modal

        within_modal do
          container = column_item(name)
          container.find('.op-draggable-autocomplete--remove-item').click
        end

        apply if save_changes
      end

      def expect_checked(name)
        within_modal do
          expect(page).to have_selector('.op-draggable-autocomplete--item', text: name)
        end
      end

      def expect_unchecked(name)
        within_modal do
          expect(page).to have_no_selector('.op-draggable-autocomplete--item', text: name)
        end
      end

      def uncheck_all(save_changes: true)
        modal_open? or open_modal

        within_modal do
          expect(page).to have_selector('.op-draggable-autocomplete--item', minimum: 1)
          page.all('.op-draggable-autocomplete--remove-item').each do |el|
            el.click
            sleep 0.2
          end
        end

        apply if save_changes
      end

      def apply
        @opened = false

        # SeleniumHubWaiter.wait
        click_button('Apply')
      end

      def open_modal
        @opened = true
        ::Components::WorkPackages::TableConfigurationModal.new(trigger_parent).open_and_switch_to 'Columns'
      end

      def assume_opened
        @opened = true
      end

      private

      def within_modal(&block)
        page.within('.wp-table--configuration-modal', &block)
      end

      def modal_open?
        !!@opened
      end
    end
  end
end
