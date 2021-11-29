

require 'spec_helper'

describe 'index users', type: :feature do
  shared_let(:current_user) { FactoryBot.create :admin, firstname: 'admin', lastname: 'admin', created_at: 1.hour.ago }
  let(:index_page) { Pages::Admin::Users::Index.new }

  before do
    login_as(current_user)
  end

  describe 'with some sortable users' do
    let!(:a_user) { FactoryBot.create :user, login: 'aa_login', firstname: 'aa_first', lastname: 'xxx_a' }
    let!(:b_user) { FactoryBot.create :user, login: 'bb_login', firstname: 'bb_first', lastname: 'nnn_b' }
    let!(:z_user) { FactoryBot.create :user, login: 'zz_login', firstname: 'zz_first', lastname: 'ccc_z' }

    it 'sorts them correctly (Regression #35012)' do
      index_page.visit!
      index_page.expect_listed(current_user, a_user, b_user, z_user)

      index_page.order_by('First name')
      index_page.expect_order(a_user, current_user, b_user, z_user)

      index_page.order_by('First name')
      index_page.expect_order(z_user, b_user, current_user, a_user)

      index_page.order_by('Last name')
      index_page.expect_order(current_user, z_user, b_user, a_user)

      index_page.order_by('Last name')
      index_page.expect_order(a_user, b_user, z_user, current_user)
    end
  end

  describe 'with some more status users' do
    shared_let(:anonymous) { FactoryBot.create :anonymous }
    shared_let(:active_user) { FactoryBot.create :user, created_at: 1.minute.ago }
    shared_let(:registered_user) { FactoryBot.create :user, status: User.statuses[:registered] }
    shared_let(:invited_user) { FactoryBot.create :user, status: User.statuses[:invited] }

    it 'shows the users by status and allows status manipulations',
       with_settings: { brute_force_block_after_failed_logins: 5,
                        brute_force_block_minutes: 10 } do
      index_page.visit!

      # Order is by id, asc
      # so first ones created are on top.
      index_page.expect_listed(current_user, active_user, registered_user, invited_user)

      index_page.order_by('Created on')
      index_page.expect_order(invited_user, registered_user, active_user, current_user)

      index_page.order_by('Created on')
      index_page.expect_order(current_user, active_user, registered_user, invited_user)

      index_page.lock_user(active_user)
      index_page.expect_listed(current_user, active_user, registered_user, invited_user)
      index_page.expect_user_locked(active_user)

      expect(active_user.reload)
        .to be_locked

      index_page.filter_by_status('locked permanently')
      index_page.expect_listed(active_user)

      index_page.filter_by_status('active')
      index_page.expect_listed(current_user)

      index_page.filter_by_status('locked permanently')
      index_page.unlock_user(active_user)
      index_page.expect_non_listed

      index_page.filter_by_status('active')
      index_page.expect_listed(current_user, active_user)

      index_page.filter_by_name(active_user.lastname[0..-3])
      index_page.expect_listed(active_user)

      # temporarily block user
      active_user.update(failed_login_count: 6,
                         last_failed_login_on: 9.minutes.ago)
      index_page.clear_filters
      index_page.expect_listed(current_user, active_user, registered_user, invited_user)

      index_page.filter_by_status('locked temporarily')
      index_page.expect_listed(active_user)

      index_page.reset_failed_logins(active_user)
      index_page.expect_non_listed

      # temporarily block user and lock permanently
      active_user.reload
      active_user.update(failed_login_count: 6,
                         last_failed_login_on: 9.minutes.ago)
      index_page.clear_filters

      index_page.filter_by_status('locked temporarily')
      index_page.expect_listed(active_user)

      index_page.lock_user(active_user)
      index_page.expect_listed(active_user)

      index_page.filter_by_status('locked permanently')
      index_page.expect_listed(active_user)

      index_page.unlock_and_reset_user(active_user)
      index_page.expect_non_listed

      index_page.filter_by_status('active')
      index_page.expect_listed(current_user, active_user)

      # activate registered user
      index_page.filter_by_status('registered')
      index_page.expect_listed(registered_user)

      index_page.activate_user(registered_user)
      index_page.filter_by_status('active')

      index_page.expect_listed(current_user, active_user, registered_user)
    end

    context 'as global user' do
      shared_let(:global_manage_user) { FactoryBot.create :user, global_permission: :manage_user }
      let(:current_user) { global_manage_user }

      it 'can too visit the page' do
        index_page.visit!
        index_page.expect_listed(current_user, active_user, registered_user, invited_user)
      end
    end
  end
end
