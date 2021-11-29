

require 'spec_helper'

describe 'Test mail notification', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
    visit admin_settings_mail_notifications_path(tab: :notifications)
  end

  it 'shows the correct message on errors in test notification (Regression #28226)' do
    error_message = '"error" with <strong>Markup?</strong>'
    expect(UserMailer).to receive(:test_mail).with(admin)
      .and_raise error_message

    click_link 'Send a test email'

    expected = "An error occurred while sending mail (#{error_message})"
    expect(page).to have_selector('.flash.error', text: expected)
    expect(page).to have_no_selector('.flash.error strong')
  end
end
