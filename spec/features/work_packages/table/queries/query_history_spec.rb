

require 'spec_helper'

describe 'Going back and forth through the browser history', type: :feature, js: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:project) { FactoryBot.create(:project) }
  let(:type) { project.types.first }
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_work_packages
                                      save_queries])
  end

  let(:work_package_1) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type)
  end
  let(:work_package_2) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type,
                      assigned_to: user)
  end
  let(:version) do
    FactoryBot.create(:version,
                      project: project)
  end
  let(:work_package_3) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: type,
                      version: version)
  end
  let(:assignee_query) do
    query = FactoryBot.create(:query,
                              name: 'Assignee Query',
                              project: project,
                              user: user)

    query.add_filter('assigned_to_id', '=', [user.id])
    query.save!

    query
  end
  let(:version_query) do
    query = FactoryBot.create(:query,
                              name: 'Version Query',
                              project: project,
                              user: user)

    query.add_filter('version_id', '=', [version.id])
    query.save!

    query
  end
  let(:wp_table) { Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }

  before do
    login_as(user)

    work_package_1
    work_package_2
    work_package_3

    assignee_query
    version_query
  end

  it 'updates the filters and query results on history back and forth', retry: 1 do
    wp_table.visit!
    wp_table.expect_title('All open', editable: true)

    wp_table.visit_query(assignee_query)
    wp_table.expect_title(assignee_query.name)
    wp_table.expect_work_package_listed work_package_2

    wp_table.visit_query(version_query)
    wp_table.expect_title(version_query.name)
    wp_table.expect_work_package_listed work_package_3

    filters.open
    filters.add_filter_by('Assignee', 'is', user.name)
    filters.expect_filter_count 3
    wp_table.expect_no_work_package_listed

    page.execute_script('window.history.back()')

    wp_table.expect_title(version_query.name)
    wp_table.expect_work_package_listed work_package_3
    filters.expect_filter_count 2
    filters.expect_filter_by('Status', 'open', nil)
    filters.expect_filter_by('Version', 'is', version.name)

    page.execute_script('window.history.back()')

    wp_table.expect_title(assignee_query.name)
    wp_table.expect_work_package_listed work_package_2
    filters.open
    filters.expect_filter_by('Status', 'open', nil)
    filters.expect_filter_by('Assignee', 'is', user.name)

    page.execute_script('window.history.back()')

    wp_table.expect_title('All open', editable: true)
    wp_table.expect_work_package_listed work_package_1
    wp_table.expect_work_package_listed work_package_2
    wp_table.expect_work_package_listed work_package_3
    filters.open
    filters.expect_filter_by('Status', 'open', nil)

    page.execute_script('window.history.forward()')

    wp_table.expect_title(assignee_query.name)
    wp_table.expect_work_package_listed work_package_2
    filters.open
    filters.expect_filter_by('Status', 'open', nil)
    filters.expect_filter_by('Assignee', 'is', user.name)

    page.execute_script('window.history.forward()')

    wp_table.expect_title(version_query.name)
    wp_table.expect_work_package_listed work_package_3
    filters.open
    filters.expect_filter_by('Status', 'open', nil)
    filters.expect_filter_by('Version', 'is', version.name)

    page.execute_script('window.history.forward()')

    wp_table.expect_title(version_query.name)
    wp_table.expect_no_work_package_listed
    filters.open
    filters.expect_filter_by('Status', 'open', nil)
    filters.expect_filter_by('Version', 'is', version.name)
    filters.expect_filter_by('Assignee', 'is', user.name)
  end
end
