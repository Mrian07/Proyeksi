

require 'spec_helper'

describe 'Expire old user sessions',
         with_config: { session_store: :active_record_store },
         type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:admin_password) { 'adminADMIN!' }

  before do
    login_with(admin.login, admin_password)

    # Create a dangling session
    Capybara.current_session.driver.browser.clear_cookies
  end

  describe 'logging in again' do
    context 'with drop_old_sessions enabled', with_config: { drop_old_sessions_on_login: true } do
      it 'destroys the old session' do
        expect(::Sessions::UserSession.count).to eq(1)

        first_session = ::Sessions::UserSession.first
        expect(first_session.user_id).to eq(admin.id)

        # Actually login now
        login_with(admin.login, admin_password)

        expect(::Sessions::UserSession.count).to eq(1)
        second_session = ::Sessions::UserSession.first

        expect(second_session.user_id).to eq(admin.id)
        expect(second_session.session_id).not_to eq(first_session.session_id)
      end
    end

    context 'with drop_old_sessions disabled', with_config: { drop_old_sessions_on_login: false } do
      it 'keeps the old session' do
        # Actually login now
        login_with(admin.login, admin_password)

        expect(::Sessions::UserSession.for_user(admin).count).to eq(2)
      end
    end
  end

  describe 'logging out on another session', with_config: { drop_old_sessions_on_login: false } do
    before do
      # Actually login now
      login_with(admin.login, admin_password)
      expect(::Sessions::UserSession.for_user(admin).count).to eq(2)
      visit '/logout'
    end

    context 'with drop_old_sessions enabled', with_config: { drop_old_sessions_on_logout: true } do
      it 'destroys the old session' do
        # A fresh session is opened due to reset_session
        expect(::Sessions::UserSession.for_user(admin).count).to eq(0)
        expect(::Sessions::UserSession.non_user.count).to eq(1)
      end
    end

    context 'with drop_old_sessions disabled',
            with_config: { drop_old_sessions_on_logout: false } do
      it 'keeps the old session' do
        expect(::Sessions::UserSession.count).to eq(2)
        expect(::Sessions::UserSession.for_user(admin).count).to eq(1)
      end
    end
  end
end
