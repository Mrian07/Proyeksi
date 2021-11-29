

require 'spec_helper'

describe 'Global role: Global Create project', type: :feature, js: true do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create :project }

  before do
    login_as(user)
  end

  describe 'Create Project is not a member permission' do
    # Given there is a role "Member"
    let!(:role) { FactoryBot.create(:role, name: 'Member') }

    # And I am already admin
    # When I go to the edit page of the role "Member"
    # Then I should not see "Create project"
    it 'does not show the global permission' do
      visit edit_role_path(role)
      expect(page).to have_selector('.form--label-with-check-box', text: 'Edit project')
      expect(page).to have_no_selector('.form--label-with-check-box', text: 'Create project')
    end
  end

  describe 'Create Project is a global permission' do
    # Given there is a global role "Global"
    let!(:role) { FactoryBot.create(:global_role, name: 'Global') }
    # And I am already admin
    # When I go to the edit page of the role "Global"
    # Then I should see "Create project"
    it 'does show the global permission' do
      visit edit_role_path(role)
      expect(page).to have_no_selector('.form--label-with-check-box', text: 'Edit project')
      expect(page).to have_selector('.form--label-with-check-box', text: 'Create project')
    end
  end

  describe 'Create Project displayed to user' do
    let!(:global_role) { FactoryBot.create(:global_role, name: 'Global', permissions: %i[add_project]) }
    let!(:member_role) { FactoryBot.create(:role, name: 'Member', permissions: %i[view_project]) }

    let(:user) { FactoryBot.create :user }
    let!(:global_member) do
      FactoryBot.create(:global_member,
                        principal: user,
                        roles: [global_role])
    end

    let(:name_field) { ::FormFields::InputFormField.new :name }

    it 'does show the global permission' do
      visit projects_path
      expect(page).to have_selector('.button.-alt-highlight', text: 'Project')

      # Can add new project
      visit new_project_path

      name_field.set_value 'New project name'

      page.find('button:not([disabled])', text: 'Save').click

      expect(page).to have_current_path '/projects/new-project-name/'
    end
  end

  describe 'Create Project not displayed to user without global role' do
    # Given there is 1 User with:
    # | Login | bob |
    # | Firstname | Bob |
    # | Lastname | Bobbit |
    #   When I am already logged in as "bob"
    let(:user) { FactoryBot.create :user }
    it 'does show the global permission' do
      # And I go to the overall projects page
      visit projects_path
      # Then I should not see "Project" within ".toolbar-items"
      expect(page).to have_no_selector('.button.-alt-highlight', text: 'Project')
    end
  end
end
