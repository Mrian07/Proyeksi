

require 'spec_helper'

describe UsersHelper, type: :helper do
  include UsersHelper

  def build_user(status, blocked)
    FactoryBot.build_stubbed(:user,
                             status: status,
                             failed_login_count: 3).tap do |user|
      allow(user)
        .to receive(:failed_too_many_recent_login_attempts?)
        .and_return(blocked)
    end
  end

  describe 'full_user_status' do
    test_cases = {
      [:active, false] => I18n.t(:active, scope: :user),
      [:active, true] => I18n.t(:blocked_num_failed_logins,
                                count: 3,
                                scope: :user),
      [:locked, false] => I18n.t(:locked, scope: :user),
      [:locked, true] => I18n.t(:status_user_and_brute_force,
                                user: I18n.t(:locked, scope: :user),
                                brute_force: I18n.t(:blocked_num_failed_logins,
                                                    count: 3,
                                                    scope: :user),
                                scope: :user),
      [:registered, false] => I18n.t(:registered, scope: :user),
      [:registered, true] => I18n.t(:status_user_and_brute_force,
                                    user: I18n.t(:registered, scope: :user),
                                    brute_force: I18n.t(:blocked_num_failed_logins,
                                                        count: 3,
                                                        scope: :user),
                                    scope: :user)
    }

    test_cases.each do |(status, blocked), expectation|
      describe "with status #{status} and blocked #{blocked}" do
        before do
          user = build_user(status, blocked)
          @status = full_user_status(user, true)
        end

        it "should return #{expectation}" do
          expect(@status).to eq(expectation)
        end
      end
    end
  end

  describe 'change_user_status_buttons' do
    test_cases = {
      [:active, false] => :lock,
      [:locked, false] => :unlock,
      [:locked, true] => :unlock_and_reset_failed_logins,
      [:registered, false] => :activate,
      [:registered, true] => :activate_and_reset_failed_logins
    }

    test_cases.each do |(status, blocked), expectation_symbol|
      describe "with status #{status} and blocked #{blocked}" do
        expectation = I18n.t(expectation_symbol, scope: :user)
        before do
          user = build_user(status, blocked)
          @buttons = change_user_status_buttons(user)
        end
        it "should contain '#{expectation}'" do
          expect(@buttons).to include(expectation)
        end

        it 'should contain a single button' do
          expect(@buttons.scan('<input').count).to eq(1)
        end
      end
    end

    describe 'with status active and blocked True' do
      before do
        user = build_user(:active, true)
        @buttons = change_user_status_buttons(user)
      end

      it 'should return inputs (buttons)' do
        expect(@buttons.scan('<input').count).to eq(2)
      end

      it "should contain 'Lock' and 'Reset Failed logins'" do
        expect(@buttons).to include(I18n.t(:lock, scope: :user))
        expect(@buttons).to include(I18n.t(:reset_failed_logins, scope: :user))
      end
    end
  end
end
