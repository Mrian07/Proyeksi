

require_relative '../filters'

module Components
  module WorkPackages
    module TableConfiguration
      class Filters < ::Components::WorkPackages::Filters
        attr_reader :modal

        def initialize
          @modal = ::Components::WorkPackages::TableConfigurationModal.new
        end

        def open
          modal.open_and_switch_to 'Filters'
          expect_open
        end

        def save
          modal.save
        end

        def expect_filter_count(count)
          within(modal.selector) do
            expect(page).to have_selector('.advanced-filters--filter', count: count)
          end
        end

        def expect_open
          modal.expect_open
          expect(page).to have_selector('.op-tab-row--link_selected', text: 'FILTERS')
        end

        def expect_closed
          modal.expect_closed
        end
      end
    end
  end
end
