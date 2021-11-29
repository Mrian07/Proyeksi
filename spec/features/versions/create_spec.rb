

require 'spec_helper'

describe 'version create', type: :feature, js: false do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[manage_versions view_work_packages])
  end
  let(:project) { FactoryBot.create(:project) }
  let(:new_version_name) { 'A new version name' }

  before do
    login_as(user)
  end

  context 'create a version' do
    it 'and redirect to default' do
      visit new_project_version_path(project)

      fill_in 'Name', with: new_version_name
      click_on 'Create'

      expect(page).to have_current_path(project_settings_versions_path(project))
      expect(page).to have_content new_version_name
    end

    it 'and redirect back to where you started' do
      visit project_roadmap_path(project)
      click_on 'New version'

      fill_in 'Name', with: new_version_name
      click_on 'Create'

      expect(page).to have_text("Successful creation")
      expect(page).to have_current_path(project_roadmap_path(project))
      expect(page).to have_content new_version_name
    end
  end
end
