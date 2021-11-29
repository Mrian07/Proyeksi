

require 'spec_helper'

describe 'Work package filtering by responsible', js: true do
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

  let!(:work_package_user_responsible) do
    FactoryBot.create :work_package,
                      project: project,
                      responsible: other_user
  end
  let!(:work_package_placeholder_user_responsible) do
    FactoryBot.create :work_package,
                      project: project,
                      responsible: placeholder_user
  end

  current_user do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  it 'shows the work package matching the responsible filter' do
    wp_table.visit!
    wp_table.expect_work_package_listed(work_package_user_responsible, work_package_placeholder_user_responsible)

    filters.open
    filters.add_filter_by('Accountable', 'is', [other_user.name], 'responsible')

    wp_table.ensure_work_package_not_listed!(work_package_placeholder_user_responsible)
    wp_table.expect_work_package_listed(work_package_user_responsible)

    wp_table.save_as('Responsible query')

    wp_table.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Revisit query
    wp_table.visit_query Query.last
    wp_table.ensure_work_package_not_listed!(work_package_placeholder_user_responsible)
    wp_table.expect_work_package_listed(work_package_user_responsible)

    filters.open
    filters.expect_filter_by('Accountable', 'is', [other_user.name], 'responsible')
    filters.remove_filter 'responsible'
    filters.add_filter_by('Accountable', 'is', [placeholder_user.name], 'responsible')

    wp_table.ensure_work_package_not_listed!(work_package_user_responsible)
    wp_table.expect_work_package_listed(work_package_placeholder_user_responsible)
  end
end
