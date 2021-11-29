

require 'spec_helper'

describe 'menu permissions', type: :feature, js: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[manage_versions view_work_packages])
  end
  let(:admin) { FactoryBot.create(:admin) }

  let(:project) { FactoryBot.create(:project) }

  context 'as an admin' do
    before do
      login_as(admin)

      # Allowed to see the settings version page
      visit project_settings_versions_path(project)
    end

    it 'I can see all menu entries' do
      expect(page).to have_selector('#menu-sidebar .op-menu--item-title', text: 'Versions')
      expect(page).to have_selector('#menu-sidebar .op-menu--item-title', text: 'Information')
      expect(page).to have_selector('#menu-sidebar .op-menu--item-title', text: 'Modules')
    end

    it 'the parent node directs to the general settings page' do
      # The settings menu item exists
      expect(page).to have_selector('#menu-sidebar .main-item-wrapper', text: 'Project settings', visible: false)

      # Clicking the menu parent item leads to the version page
      find('.main-menu--parent-node', text: 'Project settings').click
      expect(page).to have_current_path "/projects/#{project.identifier}/settings/general/"
    end
  end

  context 'as an user who can only manage_versions' do
    before do
      login_as(user)

      # Allowed to see the settings version page
      visit project_settings_versions_path(project)
    end

    it 'I can only see the version settings page' do
      expect(page).to have_selector('#menu-sidebar .op-menu--item-title', text: 'Versions')
      expect(page).not_to have_selector('#menu-sidebar .op-menu--item-title', text: 'Information')
      expect(page).not_to have_selector('#menu-sidebar .op-menu--item-title', text: 'Modules')
    end

    it 'the parent node directs to the only visible children page' do
      # The settings menu item exists
      expect(page).to have_selector('#menu-sidebar .main-item-wrapper', text: 'Project settings', visible: false)

      # Clicking the menu parent item leads to the version page
      find('.main-menu--parent-node', text: 'Project settings').click
      expect(page).to have_current_path(project_settings_versions_path(project))
    end
  end
end
