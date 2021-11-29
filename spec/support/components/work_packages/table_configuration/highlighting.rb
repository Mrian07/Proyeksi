

module Components
  module WorkPackages
    class Highlighting
      include Capybara::DSL
      include RSpec::Matchers

      def initialize; end

      def switch_highlighting_mode(label)
        modal_open? or open_modal
        choose label

        apply
      end

      def switch_entire_row_highlight(label)
        modal_open? or open_modal
        choose "Entire row by"

        # Open select field
        within(page.all(".form--field")[1]) do
          page.find('.ng-input input').click
        end
        page.find('.ng-dropdown-panel .ng-option', text: label).click
        apply
      end

      def switch_inline_attribute_highlight(*labels)
        modal_open? or open_modal
        choose "Highlighted attribute(s)"

        # Open select field
        within(page.all(".form--field")[0]) do
          page.find('.ng-input input').click
        end

        # Delete all previously selected options
        page.all('.ng-dropdown-panel .ng-option-selected').each { |option| option.click }

        labels.each do |label|
          page.find('.ng-dropdown-panel .ng-option', text: label).click
        end

        apply
      end

      def apply
        @opened = false

        click_button('Apply')
      end

      def open_modal
        @opened = true
        ::Components::WorkPackages::SettingsMenu.new.open_and_choose 'Configure view'

        retry_block do
          find(".op-tab-row--link", text: 'HIGHLIGHTING', wait: 10).click
        end
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
