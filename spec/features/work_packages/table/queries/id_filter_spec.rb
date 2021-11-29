

require 'spec_helper'

describe 'Work package filtering by id', js: true do
  let(:project) { FactoryBot.create :project }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }
  let(:role) { FactoryBot.create(:role, permissions: %i[view_work_packages save_queries]) }

  let!(:work_package) do
    FactoryBot.create :work_package,
                      project: project
  end
  let!(:other_work_package) do
    FactoryBot.create :work_package,
                      project: project

  end

  current_user do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  it 'shows the work package matching the id filter' do
    wp_table.visit!
    wp_table.expect_work_package_listed(work_package, other_work_package)

    filters.open
    filters.add_filter_by('ID', 'is', [work_package.subject])

    wp_table.ensure_work_package_not_listed!(other_work_package)
    wp_table.expect_work_package_listed(work_package)

    wp_table.save_as('Id query')

    wp_table.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Revisit query
    wp_table.visit_query Query.last
    wp_table.ensure_work_package_not_listed!(other_work_package)
    wp_table.expect_work_package_listed(work_package)

    filters.open
    filters.expect_filter_by('ID', 'is', [work_package.subject])
    filters.remove_filter 'id'
    filters.add_filter_by('ID', 'is not', [work_package.subject, other_work_package.subject])

    wp_table.expect_no_work_package_listed
  end
end
