

require 'spec_helper'

describe 'Menu item traversal', type: :feature do
  shared_let(:admin) { FactoryBot.create(:admin) }

  describe 'EnterpriseToken management' do
    before do
      login_as(admin)
      visit admin_index_path
    end

    it 'correctly maps the menu items for controllers in their namespace (Regression #30859)' do
      expect(page).to have_selector('.admin-overview-menu-item.selected', text: 'Overview')

      find('.plugin-webhooks-menu-item').click

      # using `controller_name` in `menu_controller.rb` has broken this example,
      # due to the plugin controller also being named 'admin' thus falling back to 'admin#index' => overview selected
      expect(page).to have_selector('.plugin-webhooks-menu-item.selected', text: 'Webhooks', wait: 5)
      expect(page).to have_no_selector('.admin-overview-menu-item.selected')
    end
  end

  describe 'route authorization', with_settings: { login_required?: false } do
    let(:user) { FactoryBot.create :user }
    let(:anon) { User.anonymous }

    let(:check_link) do
      ->(link) {
        visit link

        if current_url.include? "/login?back_url="
          expect(page).to have_text('Sign in'), "#{link} should redirect to sign in"
        else
          expect(page).to have_text(I18n.t(:notice_not_authorized)), "#{link} should result in 403 response"
        end
      }
    end

    let(:check_authorized_link) do
      ->(link) {
        visit link

        expect(current_url).to include link
        expect(page).to have_http_status(200)
        expect(page).to have_no_text(I18n.t(:notice_not_authorized))
        expect(page).to have_selector '#menu-sidebar .selected'
      }
    end

    it 'checks for authorized status for all links' do
      login_as admin
      visit admin_index_path

      # Get all admin links from there
      links = all('#menu-sidebar a[href]', visible: :all)
        .map { |node| node['href'] }
        .reject { |link| link.end_with? '/#' }
        .compact
        .uniq

      links.each(&check_authorized_link)

      login_as anon
      links.each(&check_link)

      login_as user
      links.each(&check_link)
    end
  end
end
