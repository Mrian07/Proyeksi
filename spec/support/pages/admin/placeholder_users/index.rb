

require 'support/pages/page'

module Pages
  module Admin
    module PlaceholderUsers
      class Index < ::Pages::Page
        def path
          "/placeholder_users"
        end

        def expect_listed(*placeholder_users)
          rows = page.all 'td.name'
          expect(rows.map(&:text)).to include(*placeholder_users.map(&:name))
        end

        def expect_ordered(*placeholder_users)
          rows = page.all 'td.name'
          expect(rows.map(&:text)).to eq(placeholder_users.map(&:name))
        end

        def expect_not_listed(*users)
          rows = page.all 'td.name'
          expect(rows.map(&:text)).to_not include(*users.map(&:name))
        end

        def expect_non_listed
          expect(page)
            .to have_no_selector('tr.placeholder-user')

          expect(page)
            .to have_selector('tr.generic-table--empty-row', text: 'There is currently nothing to display.')
        end

        def filter_by_name(value)
          fill_in 'Name', with: value
          click_button 'Apply'
        end

        def clear_filters
          click_link 'Clear'
        end

        def order_by(key)
          within 'thead' do
            click_link key
          end
        end

        def expect_no_delete_button_for_all_rows
          expect(page).to have_selector('i.icon-help2')
        end

        def expect_no_delete_button(placeholder_user)
          within_placeholder_user_row(placeholder_user) do
            expect(page).to have_selector('i.icon-help2')
          end
        end

        def expect_delete_button(placeholder_user)
          within_placeholder_user_row(placeholder_user) do
            expect(page).to have_selector('i.icon-delete')
          end
        end

        def click_placeholder_user_button(placeholder_user, text)
          within_placeholder_user_row(placeholder_user) do
            click_link text
          end
        end

        private

        def within_placeholder_user_row(placeholder_user)
          row = find('tr.placeholder_user td.name', text: placeholder_user.name).ancestor('tr')
          within row do
            yield
          end
        end
      end
    end
  end
end
