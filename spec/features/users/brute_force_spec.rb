

require 'spec_helper'

describe 'Loggin (with brute force protection)', type: :feature do
  let(:login) { 'my_user' }
  let(:password) { "PassW0rd!!!" }
  let(:invalid_password) { password[0..-2] }
  let!(:user) do
    FactoryBot.create(:user,
                      login: login,
                      password: password,
                      password_confirmation: password)
  end

  def new_login_attempt(login_attempt, password_attempt)
    # The login name already provided is retained
    expect(page)
      .to have_field 'Username', with: login_attempt

    login_with(login_attempt, password_attempt)
  end

  def pretend_to_have_waited(time)
    User
      .where(id: user.id)
      .update_all(last_failed_login_on: time)
  end

  it 'blocks login attempts after too many tries for the configured time',
     with_settings: { brute_force_block_minutes: 5, brute_force_block_after_failed_logins: 2 } do
    login_with login, invalid_password

    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials_or_blocked))

    new_login_attempt(login, invalid_password)

    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials_or_blocked))

    new_login_attempt(login, password)

    # Too many attempts
    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials_or_blocked))

    # Pretend the user waited some time
    wait_time = 4.minutes.ago
    pretend_to_have_waited(wait_time)

    # Do not wait long enough
    new_login_attempt(login, password)

    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials_or_blocked))

    # Pretend the user waited some time
    wait_time = 5.minutes.ago - 1.second
    pretend_to_have_waited(wait_time)

    # Wait long enough
    new_login_attempt(login, password)

    expect(page)
      .to have_current_path my_page_path

    # resets the failed login count
    expect(User.where(id: user.id).pluck(:failed_login_count).first)
      .to eql 0
  end

  it 'does not block if brute force is disabled',
     with_settings: { brute_force_block_minutes: 5, brute_force_block_after_failed_logins: 0 } do
    login_with login, invalid_password

    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials))

    new_login_attempt(login, invalid_password)

    expect(page)
      .to have_content(I18n.t(:notice_account_invalid_credentials))

    new_login_attempt(login, password)

    expect(page)
      .to have_current_path my_page_path
  end
end
