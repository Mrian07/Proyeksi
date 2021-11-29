

require 'spec_helper'

feature 'group memberships through groups page', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let!(:project) { FactoryBot.create :project, name: 'Project 1', identifier: 'project1' }

  let!(:peter) do
    FactoryBot.create :user,
                      firstname: 'Peter',
                      lastname: 'Pan',
                      mail: 'foo@example.org',
                      member_in_project: project,
                      member_through_role: role,
                      preferences: { hide_mail: false }
  end

  let!(:hannibal) do
    FactoryBot.create :user,
                      firstname: 'Pan',
                      lastname: 'Hannibal',
                      mail: 'foo@example.com',
                      member_in_project: project,
                      member_through_role: role,
                      preferences: { hide_mail: true }
  end
  let(:role) { FactoryBot.create(:role, permissions: %i(add_work_packages)) }
  let(:members_page) { Pages::Members.new project.identifier }

  before do
    login_as(admin)
    members_page.visit!
    expect_angular_frontend_initialized
  end

  scenario 'filters users based on some name attribute' do
    members_page.open_filters!

    members_page.search_for_name 'pan'
    members_page.find_user 'Pan Hannibal'
    expect(page).to have_no_selector('td.mail', text: hannibal.mail)
    members_page.find_user 'Peter Pan'
    members_page.find_mail peter.mail

    members_page.search_for_name '@example'
    members_page.find_user 'Pan Hannibal'
    expect(page).to have_no_selector('td.mail', text: hannibal.mail)
    members_page.find_user 'Peter Pan'
    members_page.find_mail peter.mail

    members_page.search_for_name '@example.org'
    members_page.find_user 'Peter Pan'
    members_page.find_mail peter.mail
    expect(page).to have_no_selector('td.mail', text: hannibal.mail)
  end
end
