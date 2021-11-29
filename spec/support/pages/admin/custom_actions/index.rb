

require 'support/pages/page'

module Pages
  module Admin
    module CustomActions
      class Index < ::Pages::Page
        def new
          within '.toolbar-items' do
            click_link 'Custom action'
          end

          Pages::Admin::CustomActions::New.new
        end

        def edit(name)
          within_buttons_of name do
            find('.icon-edit').click
          end

          custom_action = CustomAction.find_by!(name: name)
          Pages::Admin::CustomActions::Edit.new(custom_action)
        end

        def delete(name)
          within_buttons_of name do
            find('.icon-delete').click

            accept_alert_dialog!
          end
        end

        def expect_listed(*names)
          within 'table' do
            Array(names).each do |name|
              expect(page)
                .to have_content name
            end
          end
        end

        def move_top(name)
          within_row_of(name) do
            click_link 'Move to top'
          end
        end

        def move_bottom(name)
          within_row_of(name) do
            click_link 'Move to bottom'
          end
        end

        def move_up(name)
          within_row_of(name) do
            click_link 'Move up'
          end
        end

        def move_down(name)
          within_row_of(name) do
            click_link 'Move down'
          end
        end

        def path
          custom_actions_path
        end

        private

        def within_row_of(name, &block)
          within 'table' do
            within find('tr', text: name), &block
          end
        end

        def within_buttons_of(name, &block)
          within_row_of(name) do
            within find('.buttons'), &block
          end
        end
      end
    end
  end
end
