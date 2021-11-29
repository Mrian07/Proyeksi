

require 'spec_helper'

RSpec.feature 'Work package index view' do
  let(:user) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[work_package_tracking]) }
  let(:wp_table) { Pages::WorkPackagesTable.new(project) }

  before do
    login_as(user)
  end

  scenario 'is reachable by clicking the sidebar menu item', js: true do
    visit project_path(project)

    within('#content') do
      expect(page).to have_content('Overview')
    end

    within('#main-menu') do
      click_link 'Work package'
    end

    expect(current_path).to eql("/projects/#{project.identifier}/work_packages")
    within('#content') do
      wp_table.expect_title('All open', editable: true)
      expect(page).to have_content('No work packages to display')
    end
  end
end
