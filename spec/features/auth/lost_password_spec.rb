

require 'spec_helper'

describe 'Lost password', type: :feature do
  let!(:user) { FactoryBot.create :user }
  let(:new_password) { "new_PassW0rd!" }

  it 'allows logging in after having lost the password' do
    visit account_lost_password_path

    # shows same flash for invalid and existing users
    fill_in 'mail', with: 'invalid mail'
    click_on 'Submit'

    expect(page).to have_selector('.flash.notice', text: I18n.t(:notice_account_lost_email_sent))

    perform_enqueued_jobs
    expect(ActionMailer::Base.deliveries.size).to eql 0

    fill_in 'mail', with: user.mail
    click_on 'Submit'
    expect(page).to have_selector('.flash.notice', text: I18n.t(:notice_account_lost_email_sent))

    perform_enqueued_jobs
    expect(ActionMailer::Base.deliveries.size).to eql 1

    # mimic the user clicking on the link in the mail
    token = Token::Recovery.first
    visit account_lost_password_path(token: token.value)

    fill_in 'New password', with: new_password
    fill_in 'Confirmation', with: new_password

    click_button 'Save'

    expect(page).to have_selector('.flash.notice', text: I18n.t(:notice_account_password_updated))

    login_with user.login, new_password

    expect(page)
      .to have_current_path(my_page_path)
  end
end
