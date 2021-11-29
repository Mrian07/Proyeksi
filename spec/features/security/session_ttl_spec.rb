

require 'spec_helper'

describe 'Session TTL',
         with_settings: { session_ttl_enabled?: true, session_ttl: '10' },
         type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:admin_password) { 'adminADMIN!' }

  let!(:work_package) { FactoryBot.create :work_package }

  before do
    login_with(admin.login, admin_password)
  end

  def expire!
    page.set_rack_session(updated_at: Time.now - 1.hour)
  end

  describe 'outdated TTL on Rails request' do
    it 'expires on the next Rails request' do
      visit '/my/account'
      expect(page).to have_selector('.form--field-container', text: admin.login)

      # Expire the session
      expire!

      visit '/'
      expect(page).to have_selector('.action-login')
    end
  end

  describe 'outdated TTL on API request' do
    it 'expires on the next APIv3 request' do
      page.driver.header('X-Requested-With', 'XMLHttpRequest')
      visit "/api/v3/work_packages/#{work_package.id}"

      body = JSON.parse(page.body)
      expect(body['id']).to eq(work_package.id)

      # Expire the session
      expire!
      visit "/api/v3/work_packages/#{work_package.id}"

      expect(page.body).to eq('unauthorized')
    end
  end
end
