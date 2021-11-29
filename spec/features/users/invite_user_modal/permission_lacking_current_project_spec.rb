

require 'spec_helper'

describe 'Inviting user in project the current user is lacking permission in', type: :feature, js: true do
  let(:modal) do
    ::Components::Users::InviteUserModal.new project: invite_project,
                                             principal: other_user,
                                             role: view_role
  end
  let(:quick_add) { ::Components::QuickAddMenu.new }

  let(:view_role) do
    FactoryBot.create :role,
                      permissions: []
  end
  let(:invite_role) do
    FactoryBot.create :role,
                      permissions: %i[manage_members]
  end

  let!(:other_user) { FactoryBot.create(:user) }
  let!(:view_project) { FactoryBot.create(:project, members: { current_user => view_role }) }
  let!(:invite_project) { FactoryBot.create(:project, members: { current_user => invite_role }) }

  current_user do
    FactoryBot.create :user
  end

  it 'user cannot invite in current project but for different one' do
    visit project_path(view_project)

    quick_add.expect_visible

    quick_add.toggle

    quick_add.click_link 'Invite user'

    modal.expect_help_displayed I18n.t('js.invite_user_modal.project.lacking_permission_info')

    # Attempting to proceed without having a different project selected

    modal.select_type 'User'

    modal.click_next

    modal.expect_error_displayed I18n.t('js.invite_user_modal.project.lacking_permission')

    # Proceeding with a different project
    modal.autocomplete(invite_project.name)
    modal.click_next

    # Remaining steps
    modal.principal_step
    modal.role_step
    modal.invitation_step

    modal.expect_text "Invite #{other_user.name} to #{invite_project.name}"
    modal.confirmation_step

    modal.click_modal_button 'Send invitation'
    modal.expect_text "#{other_user.name} was invited!"

    # Expect to be added to project
    expect(invite_project.users)
      .to include(other_user)
  end
end
