

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'Work Package table cost entries', type: :feature, js: true do
  let(:project) { FactoryBot.create :project }
  let(:user) { FactoryBot.create :admin }

  let(:parent) { FactoryBot.create :work_package, project: project }
  let(:work_package) { FactoryBot.create :work_package, project: project, parent: parent }
  let(:hourly_rate) { FactoryBot.create :default_hourly_rate, user: user, rate: 1.00 }

  let!(:time_entry1) do
    FactoryBot.create :time_entry,
                      user: user,
                      work_package: parent,
                      project: project,
                      hours: 10
  end

  let!(:time_entry2) do
    FactoryBot.create :time_entry,
                      user: user,
                      work_package: work_package,
                      project: project,
                      hours: 2.50
  end

  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let!(:query) do
    query              = FactoryBot.build(:query, user: user, project: project)
    query.column_names = %w(id subject spent_hours)

    query.save!
    query
  end

  before do
    login_as(user)

    wp_table.visit_query(query)
    wp_table.expect_work_package_listed(parent)
    wp_table.expect_work_package_listed(work_package)
  end

  it 'shows the correct sum of the time entries' do
    parent_row = wp_table.row(parent)
    wp_row = wp_table.row(work_package)

    expect(parent_row).to have_selector('.inline-edit--container.spentTime', text: '12.5 h')
    expect(wp_row).to have_selector('.inline-edit--container.spentTime', text: '2.5 h')
  end

  it 'creates an activity' do
    visit project_activities_path project

    # Activate budget filter
    check('Spent time')
    check('Budgets')
    click_on 'Apply'

    expect(page).to have_selector('.time-entry a', text: '10.00 h')
    expect(page).to have_selector('.time-entry a', text: '2.50 h')
  end
end
