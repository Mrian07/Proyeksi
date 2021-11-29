

require 'spec_helper'

describe 'Filter by budget', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create :project }

  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }

  let(:member) do
    FactoryBot.create(:member,
                      user: user,
                      project: project,
                      roles: [FactoryBot.create(:role)])
  end
  let(:status) do
    FactoryBot.create(:status)
  end

  let(:budget) do
    FactoryBot.create(:budget, project: project)
  end

  let(:work_package_with_budget) do
    FactoryBot.create(:work_package,
                      project: project,
                      budget: budget)
  end

  let(:work_package_without_budget) do
    FactoryBot.create(:work_package,
                      project: project)
  end

  before do
    login_as(user)
    member
    budget
    work_package_with_budget
    work_package_without_budget

    wp_table.visit!
  end

  it 'allows filtering for budgets' do
    wp_table.expect_work_package_listed work_package_with_budget, work_package_without_budget

    filters.expect_filter_count 1
    filters.open
    filters.add_filter_by('Budget', 'is', budget.name)

    wp_table.expect_work_package_listed work_package_with_budget
    wp_table.ensure_work_package_not_listed! work_package_without_budget

    wp_table.save_as('Some query name')

    wp_table.expect_and_dismiss_toaster message: 'Successful creation.'

    filters.remove_filter 'budget'

    wp_table.expect_work_package_listed work_package_with_budget, work_package_without_budget

    last_query = Query.last

    wp_table.visit_query(last_query)

    wp_table.expect_work_package_listed work_package_with_budget
    wp_table.ensure_work_package_not_listed! work_package_without_budget

    filters.open

    filters.expect_filter_by('Budget', 'is', budget.name)
  end
end
