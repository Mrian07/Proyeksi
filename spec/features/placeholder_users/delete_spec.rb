

require 'spec_helper'

describe 'delete placeholder user', type: :feature, js: true do
  shared_let(:placeholder_user) { FactoryBot.create :placeholder_user, name: 'UX Developer' }

  shared_examples 'placeholders delete flow' do
    it 'can delete name' do
      visit placeholder_user_path(placeholder_user)

      expect(page).to have_selector '.button', text: 'Delete'

      visit edit_placeholder_user_path(placeholder_user)

      expect(page).to have_selector '.button', text: 'Delete'
      click_on 'Delete'

      # Expect to be on delete confirmation
      expect(page).to have_selector('.danger-zone--verification button[disabled]')
      fill_in 'name_verification', with: placeholder_user.name

      expect(page).to have_selector('.danger-zone--verification button:not([disabled])')
      click_on 'Delete'

      expect(page).to have_selector('.flash.info', text: I18n.t(:notice_deletion_scheduled))

      # The user is still there
      placeholder_user.reload

      perform_enqueued_jobs

      expect { placeholder_user.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'as admin' do
    current_user { FactoryBot.create :admin }

    it_behaves_like 'placeholders delete flow'
  end

  context 'as user with global permission' do
    current_user { FactoryBot.create :user, global_permission: %i[manage_placeholder_user] }

    it_behaves_like 'placeholders delete flow'
  end

  context 'as user with global permission, but placeholder in an invisble project' do
    current_user { FactoryBot.create :user, global_permission: %i[manage_placeholder_user] }

    let!(:project) { FactoryBot.create :project }
    let!(:member) do
      FactoryBot.create :member,
                        principal: placeholder_user,
                        project: project,
                        roles: [FactoryBot.create(:role)]
    end

    it 'returns an error when trying to delete and disables the button' do
      visit deletion_info_placeholder_user_path(placeholder_user)
      expect(page).to have_content I18n.t('placeholder_users.right_to_manage_members_missing').strip

      visit placeholder_user_path(placeholder_user)

      expect(page).to have_selector '.button.-disabled', text: 'Delete'

      visit edit_placeholder_user_path(placeholder_user)

      expect(page).to have_selector '.button.-disabled', text: 'Delete'
    end
  end

  context 'as user without global permission' do
    current_user { FactoryBot.create :user }

    it 'returns an error' do
      visit deletion_info_placeholder_user_path(placeholder_user)
      expect(page).to have_text 'You are not authorized to access this page.'
    end
  end
end
