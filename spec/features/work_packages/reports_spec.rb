

require 'spec_helper'

describe 'work package reports', type: :feature, js: true do
  let(:project) { FactoryBot.create :project_with_types, types: [type_a] }
  let(:user) { FactoryBot.create :user, member_in_project: project, member_with_permissions: %i(view_work_packages) }

  let(:type_a) do
    FactoryBot.create(:type_with_workflow, name: 'Type A').tap do |t|
      t.statuses.last.update_attribute(:is_closed, true)
    end
  end

  let!(:wp_1) { FactoryBot.create :work_package, project: project, type: type_a, status: type_a.statuses.first }
  let!(:wp_2) { FactoryBot.create :work_package, project: project, type: type_a, status: type_a.statuses.last }

  let(:wp_table_page) { Pages::WorkPackagesTable.new(project) }

  before do
    login_as(user)
  end

  it 'allows navigating to the reports page and drilling down' do
    wp_table_page.visit!

    within '.main-menu--children' do
      click_on 'Summary'
    end

    expect(page)
      .to have_content 'TYPE'
    expect(page)
      .to have_content 'PRIORITY'
    expect(page)
      .to have_content 'ASSIGNEE'
    expect(page)
      .to have_content 'ACCOUNTABLE'

    expect(page)
      .to have_selector 'thead th:nth-of-type(2)', text: type_a.statuses.first.name.upcase
    expect(page)
      .to have_selector 'thead th:nth-of-type(3)', text: type_a.statuses.last.name.upcase

    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(1)', text: type_a.name
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(2)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(3)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(4)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(5)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(6)', text: 2

    # Clicking on the further analyze link will lead to a page focusing on type
    click_link 'Further analyze: Type'

    expect(page)
      .to have_content 'TYPE'
    expect(page)
      .to have_no_content 'PRIORITY'
    expect(page)
      .to have_no_content 'ASSIGNEE'
    expect(page)
      .to have_no_content 'ACCOUNTABLE'

    expect(page)
      .to have_selector 'thead th:nth-of-type(2)', text: type_a.statuses.first.name.upcase
    expect(page)
      .to have_selector 'thead th:nth-of-type(3)', text: type_a.statuses.last.name.upcase

    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(1)', text: type_a.name
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(2)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(3)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(4)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(5)', text: 1
    expect(page)
      .to have_selector 'tbody tr:nth-of-type(1) td:nth-of-type(6)', text: 2

    # Clicking on a number in the table will lead to the wp list filtered by the type
    within 'tbody tr:first-of-type td:nth-of-type(2)' do
      click_link '1'
    end

    wp_table_page.expect_work_package_listed(wp_1)
    wp_table_page.ensure_work_package_not_listed!(wp_2)
  end
end
