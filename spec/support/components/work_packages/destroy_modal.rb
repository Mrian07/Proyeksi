

module Components
  module WorkPackages
    class DestroyModal
      include Capybara::DSL
      include RSpec::Matchers

      def container
        '#wp_destroy_modal'
      end

      def expect_listed(*wps)
        page.within(container) do
          if wps.length == 1
            wp = wps.first
            expect(page).to have_selector('strong', text: "#{wp.type.name} ##{wp.id} #{wp.subject}")
          else
            expect(page).to have_selector('.danger-zone--warning',
                                          text: 'Are you sure you want to delete the following work packages ?')
            wps.each do |wp|
              expect(page).to have_selector('li', text: "##{wp.id} #{wp.subject}")
            end
          end
        end
      end

      def confirm_children_deletion
        page.within(container) do
          check 'confirm-children-deletion'
        end
      end

      def confirm_deletion
        page.within(container) do
          click_button 'Confirm'
        end
      end

      def cancel_deletion
        page.within(container) do
          click_button 'Cancel'
        end
      end
    end
  end
end
