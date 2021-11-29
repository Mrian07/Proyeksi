

require 'spec_helper'
require 'features/work_packages/work_packages_page'

describe 'Work package query summary item', type: :feature, js: true do
  let(:project) { FactoryBot.create :project, identifier: 'test_project', public: false }
  let(:role) { FactoryBot.create :role, permissions: [:view_work_packages] }
  let(:work_package) { FactoryBot.create :work_package, project: project }
  let(:wp_page) { ::Pages::WorkPackagesTable.new project }
  let(:current_user) do
    FactoryBot.create :user, member_in_project: project,
                             member_through_role: role
  end

  before do
    login_as(current_user)
    wp_page.visit!
  end

  it 'allows users to visit the summary page' do
    find('.op-sidemenu--item-action', text: 'Summary', wait: 10).click
    expect(page).to have_selector('h2', text: 'Summary')
    expect(page).to have_selector('td', text: work_package.type.name)
  end
end
