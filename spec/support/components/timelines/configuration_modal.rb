

module Components
  module Timelines
    class ConfigurationModal
      include Capybara::DSL
      include RSpec::Matchers

      attr_reader :settings_menu

      def initialize
        @modal = ::Components::WorkPackages::TableConfigurationModal.new
      end

      def open!
        @modal.open_and_switch_to 'Gantt chart'
      end

      def get_select(position)
        page.find("#modal-timelines-label-#{position}")
      end

      def expect_labels!(left:, right:, farRight:)
        expect(page).to have_select('modal-timelines-label-left', selected: left)
        expect(page).to have_select('modal-timelines-label-right', selected: right)
        expect(page).to have_select('modal-timelines-label-farRight', selected: farRight)
      end

      def update_labels(left:, right:, farRight:)
        get_select(:left).find('option', text: left).select_option
        get_select(:right).find('option', text: right).select_option
        get_select(:farRight).find('option', text: farRight).select_option

        page.within '.op-modal' do
          click_on 'Apply'
        end
      end
    end
  end
end
