

require 'spec_helper'

feature 'Quick-add menu', js: true, selenium: true do
  let(:quick_add) { ::Components::QuickAddMenu.new }

  context 'as a logged in user with add_project permission' do
    current_user { FactoryBot.create :user, global_permission: %i[add_project] }

    it 'shows the add project option' do
      visit home_path

      quick_add.expect_visible
      quick_add.toggle
      quick_add.expect_add_project
      quick_add.expect_user_invite present: false
      quick_add.expect_no_work_package_types

      quick_add.click_link 'Project'
      expect(page).to have_current_path new_project_path
    end

    context 'with an existing project' do
      let(:project) { FactoryBot.create :project }
      let(:field) { ::FormFields::SelectFormField.new :parent }

      current_user do
        FactoryBot.create :user,
                          member_in_project: project,
                          member_with_permissions: %i[add_subprojects]
      end

      it 'moves to a form with parent_id set' do
        visit project_path(project)

        quick_add.expect_visible
        quick_add.toggle
        quick_add.expect_add_project

        quick_add.click_link 'Project'
        expect(page).to have_current_path new_project_path(parent_id: project.id)

        field.expect_selected project.name
      end
    end
  end

  context 'with current user as member with permission :manage_members in one project' do
    let!(:project) { FactoryBot.create :project }
    let(:invite_modal) { ::Components::Users::InviteUserModal.new project: project, role: nil, principal: nil }

    current_user do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_with_permissions: %i[manage_members]
    end

    it 'shows the user invite screen' do
      visit home_path

      quick_add.expect_visible
      quick_add.toggle
      quick_add.expect_add_project present: false
      quick_add.expect_no_work_package_types
      quick_add.expect_user_invite

      quick_add.click_link 'Invite user'
      invite_modal.expect_open
    end
  end

  context 'with a project with one of three work package types' do
    let!(:type_bug) { FactoryBot.create :type_bug }
    let!(:other_type) { FactoryBot.create :type_task }
    let!(:other_project_type) { FactoryBot.create :type }
    let!(:add_role) { FactoryBot.create(:role, permissions: %i[add_work_packages]) }
    let!(:read_role) { FactoryBot.create(:role, permissions: %i[view_work_packages]) }
    let!(:project_with_permission) do
      FactoryBot.create :project,
                        types: [type_bug],
                        members: { current_user => add_role }
    end
    let!(:other_project_with_permission) do
      FactoryBot.create :project,
                        types: [other_project_type],
                        members: { current_user => add_role }

    end
    let!(:project_without_permission) do
      FactoryBot.create :project,
                        types: [other_type],
                        members: { current_user => read_role }
    end

    current_user { FactoryBot.create :user }

    it 'shows only the project types within a project and only those types in projects the user can add work packages in' do
      visit project_path(project_with_permission)

      quick_add.expect_visible
      quick_add.toggle
      quick_add.expect_add_project present: false
      quick_add.expect_user_invite present: false
      quick_add.expect_work_package_type type_bug.name
      quick_add.expect_work_package_type other_type.name, present: false
      quick_add.expect_work_package_type other_project_type.name, present: false
      quick_add.click_link type_bug.name

      expect(page)
        .to have_current_path new_project_work_packages_path(project_id: project_with_permission, type: type_bug.id)

      visit project_path(project_without_permission)

      quick_add.expect_invisible

      visit home_path

      quick_add.expect_visible
      quick_add.toggle
      quick_add.expect_work_package_type type_bug.name
      quick_add.expect_work_package_type other_type.name, present: false
      quick_add.expect_work_package_type other_project_type.name

      quick_add.click_link other_project_type.name
      expect(page).to have_current_path new_work_packages_path(type: other_project_type.id)
    end
  end

  context 'as a logged in user with no permissions' do
    current_user { FactoryBot.create :user }

    it 'does not show the quick add menu on the home screen' do
      visit home_path
      quick_add.expect_invisible
    end
  end

  context 'as an anonymous user', with_settings: { login_required: true } do
    current_user do
      FactoryBot.create(:anonymous_role, permissions: %i[add_work_packages])
      FactoryBot.create :anonymous
    end

    it 'does not show the quick add menu on the home screen' do
      visit signin_path
      quick_add.expect_invisible
    end
  end
end
