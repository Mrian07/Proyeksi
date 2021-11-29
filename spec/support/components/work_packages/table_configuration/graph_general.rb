

module Components
  module WorkPackages
    module TableConfiguration
      class GraphGeneral
        include Capybara::DSL
        include RSpec::Matchers

        def set_type(name)
          within_modal do
            select name, from: "Chart type"
          end
        end

        def set_axis(name)
          within_modal do
            select name, from: "Axis criteria"
          end
        end

        def expect_type(name)
          within_modal do
            expect(page)
              .to have_select "Chart type", selected: name
          end
        end

        def expect_axis(name)
          within_modal do
            expect(page)
              .to have_select "Axis criteria", selected: name
          end
        end

        def apply
          within_modal do
            click_button('Apply')
          end
        end

        private

        def within_modal(&block)
          page.within('.wp-table--configuration-modal', &block)
        end
      end
    end
  end
end
