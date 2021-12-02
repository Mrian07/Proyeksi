

require 'spec_helper'

feature 'invitation spec', type: :feature, js: true do
  let(:user) { FactoryBot.create :invited_user, mail: 'holly@proyeksiapp.com' }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  shared_examples 'resends the invitation' do
    visit edit_user_path(user)
    click_on I18n.t(:label_send_invitation)
    expect(page).to have_text 'An invitation has been sent to holly@proyeksiapp.com.'

    # Logout admin
    logout

    # Visit invitation with wrong token
    visit account_activate_path(token: 'some invalid value')
    expect(page).to have_text 'Invalid activation token'

    # Visit invitation link with correct token
    visit account_activate_path(token: Token::Invitation.last.value)

    expect(page).to have_selector('.op-modal--header', text: 'Welcome to ProyeksiApp')
  end

  context 'as admin' do
    shared_let(:admin) { FactoryBot.create :admin }
    let(:current_user) { admin }
  end

  context 'as global user' do
    shared_let(:global_manage_user) { FactoryBot.create :user, global_permission: :manage_user }
    let(:current_user) { global_manage_user }
  end
end
