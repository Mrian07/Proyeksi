

require 'spec_helper'

describe 'edit placeholder users', type: :feature, js: true do
  shared_let(:placeholder_user) { FactoryBot.create :placeholder_user, name: 'UX Developer' }

  shared_examples 'placeholders edit flow' do
    it 'can edit name' do
      visit edit_placeholder_user_path(placeholder_user)

      expect(page).to have_selector '#placeholder_user_name'

      fill_in 'placeholder_user[name]', with: 'NewName', fill_options: { clear: :backspace }

      click_on 'Save'

      expect(page).to have_selector('.flash.notice', text: 'Successful update.')

      placeholder_user.reload

      expect(placeholder_user.name).to eq 'NewName'
    end
  end

  context 'as admin' do
    current_user { FactoryBot.create :admin }

    it_behaves_like 'placeholders edit flow'
  end

  context 'as user with global permission' do
    current_user { FactoryBot.create :user, global_permission: %i[manage_placeholder_user] }

    it_behaves_like 'placeholders edit flow'
  end

  context 'as user without global permission' do
    current_user { FactoryBot.create :user }

    it 'returns an error' do
      visit edit_placeholder_user_path(placeholder_user)
      expect(page).to have_text 'You are not authorized to access this page.'
    end
  end
end
