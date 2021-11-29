

require 'support/pages/page'

module Pages
  module Admin
    module Users
      class Index < ::Pages::Page
        def path
          "/users"
        end

        def expect_listed(*users)
          rows = page.all 'td.username'
          expect(rows.map(&:text)).to include(*users.map(&:login))
        end

        def expect_order(*users)
          rows = page.all 'td.username'
          expect(rows.map(&:text)).to eq(users.map(&:login))
        end

        def expect_non_listed
          expect(page)
            .to have_no_selector('tr.user')

          expect(page)
            .to have_selector('tr.generic-table--empty-row', text: 'There is currently nothing to display.')
        end

        def expect_user_locked(user)
          expect(page)
            .to have_selector('tr.user.locked td.username', text: user.login)
        end

        def filter_by_status(value)
          select value, from: 'Status:'
          click_button 'Apply'
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

        def lock_user(user)
          click_user_button(user, 'Lock permanently')
        end

        def activate_user(user)
          click_user_button(user, 'Activate')
        end

        def reset_failed_logins(user)
          click_user_button(user, 'Reset failed logins')
        end

        def unlock_user(user)
          click_user_button(user, 'Unlock')
        end

        def unlock_and_reset_user(user)
          click_user_button(user, 'Unlock and reset failed logins')
        end

        def click_user_button(user, text)
          within_user_row(user) do
            click_link text
          end
        end

        private

        def within_user_row(user, &block)
          row = find('tr.user', text: user.login)
          within row, &block
        end
      end
    end
  end
end
