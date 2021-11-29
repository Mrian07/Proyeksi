

require 'spec_helper'

describe 'Work package filtering by assignee', js: true do
  let(:project) { FactoryBot.create :project }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }
  let(:role) { FactoryBot.create(:role, permissions: %i[view_work_packages save_queries]) }
  let(:other_user) do
    FactoryBot.create :user,
                      firstname: 'Other',
                      lastname: 'User',
                      member_in_project: project,
                      member_through_role: role
  end
  let(:placeholder_user) do
    FactoryBot.create :placeholder_user,
                      member_in_project: project,
                      member_through_role: role
  end

  let!(:work_package_user_assignee) do
    FactoryBot.create :work_package,
                      project: project,
                      assigned_to: other_user
  end
  let!(:work_package_placeholder_user_assignee) do
    FactoryBot.create :work_package,
                      project: project,
                      assigned_to: placeholder_user
  end

  current_user do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  it 'shows the work package matching the assigned to filter' do
    wp_table.visit!
    wp_table.expect_work_package_listed(work_package_user_assignee, work_package_placeholder_user_assignee)

    filters.open
    filters.add_filter_by('Assignee', 'is', [other_user.name])

    wp_table.ensure_work_package_not_listed!(work_package_placeholder_user_assignee)
    wp_table.expect_work_package_listed(work_package_user_assignee)

    wp_table.save_as('Subject query')

    wp_table.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Revisit query
    wp_table.visit_query Query.last
    wp_table.ensure_work_package_not_listed!(work_package_placeholder_user_assignee)
    wp_table.expect_work_package_listed(work_package_user_assignee)

    filters.open
    filters.expect_filter_by('Assignee', 'is', [other_user.name])
    filters.remove_filter 'assignee'
    filters.add_filter_by('Assignee', 'is', [placeholder_user.name])

    wp_table.ensure_work_package_not_listed!(work_package_user_assignee)
    wp_table.expect_work_package_listed(work_package_placeholder_user_assignee)
  end
end
