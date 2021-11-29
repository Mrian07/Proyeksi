

require 'spec_helper'

describe 'Invite user modal subprojects', type: :feature, js: true do
  shared_let(:project) { FactoryBot.create :project, name: 'Parent project' }
  shared_let(:subproject) { FactoryBot.create :project, name: 'Subproject', parent: project }
  shared_let(:work_package) { FactoryBot.create :work_package, project: subproject }
  shared_let(:invitable_user) { FactoryBot.create :user, firstname: 'Invitable', lastname: 'User' }

  let(:permissions) { %i[view_work_packages edit_work_packages manage_members] }
  let(:global_permissions) { %i[] }
  let(:modal) do
    ::Components::Users::InviteUserModal.new project: subproject,
                                             principal: invitable_user,
                                             role: role
  end
  let!(:role) do
    FactoryBot.create :role,
                      name: 'Member',
                      permissions: permissions
  end
  let(:wp_page) { Pages::FullWorkPackage.new(work_package, project) }
  let(:assignee_field) { wp_page.edit_field :assignee }

  current_user do
    FactoryBot.create :user,
                      member_in_projects: [project, subproject],
                      member_through_role: role,
                      global_permissions: global_permissions
  end

  context 'with manage permissions in subproject' do
    it 'uses the subproject as the preselected project' do
      wp_page.visit!

      assignee_field.activate!

      find('.ng-dropdown-footer button', text: 'Invite', wait: 10).click

      modal.expect_open
      modal.within_modal do
        expect(page).to have_selector '.ng-value', text: 'Subproject'
      end

      modal.run_all_steps

      assignee_field.expect_inactive!
      assignee_field.expect_display_value invitable_user.name

      new_member = subproject.reload.member_principals.find_by(user_id: invitable_user.id)
      expect(new_member).to be_present
      expect(new_member.roles).to eq [role]
    end
  end

  context 'without manage permissions in subproject' do
    let(:permissions) { %i[view_work_packages edit_work_packages] }

    it 'does not show the invite button of the subproject' do
      wp_page.visit!

      assignee_field.activate!

      expect(page).to have_selector '.ng-dropdown-panel'

      expect(page).to have_no_selector('.ng-dropdown-footer button', text: 'Invite')
    end
  end
end
