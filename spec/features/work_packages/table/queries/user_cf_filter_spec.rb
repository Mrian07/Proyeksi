

require 'spec_helper'

describe 'Work package filtering by user custom field', js: true do
  let(:project) { FactoryBot.create :project }
  let(:type) { project.types.first }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }
  let!(:user_cf) do
    FactoryBot.create(:user_wp_custom_field).tap do |cf|
      type.custom_fields << cf
      project.work_package_custom_fields << cf
    end
  end
  let(:role) { FactoryBot.create(:role, permissions: %i[view_work_packages save_queries]) }
  let!(:other_user) do
    FactoryBot.create :user,
                      firstname: 'Other',
                      lastname: 'User',
                      member_in_project: project,
                      member_through_role: role
  end
  let!(:placeholder_user) do
    FactoryBot.create :placeholder_user,
                      member_in_project: project,
                      member_through_role: role
  end
  let!(:group) do
    FactoryBot.create :group,
                      member_in_project: project,
                      member_through_role: role
  end

  let!(:work_package_user) do
    FactoryBot.create(:work_package,
                      type: type,
                      project: project).tap do |wp|
      wp.custom_field_values = { user_cf.id => other_user }
      wp.save!
    end
  end
  let!(:work_package_placeholder) do
    FactoryBot.create(:work_package,
                      type: type,
                      project: project).tap do |wp|
      wp.custom_field_values = { user_cf.id => placeholder_user }
      wp.save!
    end
  end
  let!(:work_package_group) do
    FactoryBot.create(:work_package,
                      type: type,
                      project: project).tap do |wp|
      wp.custom_field_values = { user_cf.id => group }
      wp.save!
    end
  end

  current_user do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  it 'shows the work package matching the user cf filter' do
    wp_table.visit!
    wp_table.expect_work_package_listed(work_package_user, work_package_placeholder, work_package_group)

    filters.open

    # Filtering by user

    filters.add_filter_by(user_cf.name, 'is', [other_user.name], "customField#{user_cf.id}")

    wp_table.ensure_work_package_not_listed!(work_package_placeholder, work_package_group)
    wp_table.expect_work_package_listed(work_package_user)

    wp_table.save_as('Saved query')

    wp_table.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Revisit query
    wp_table.visit_query Query.last
    wp_table.ensure_work_package_not_listed!(work_package_placeholder, work_package_group)
    wp_table.expect_work_package_listed(work_package_user)

    filters.open
    filters.expect_filter_by(user_cf.name, 'is', [other_user.name], "customField#{user_cf.id}")

    # Filtering by placeholder

    filters.remove_filter "customField#{user_cf.id}"
    filters.add_filter_by(user_cf.name, 'is', [placeholder_user.name], "customField#{user_cf.id}")

    wp_table.ensure_work_package_not_listed!(work_package_user, work_package_group)
    wp_table.expect_work_package_listed(work_package_placeholder)

    # Filtering by group

    filters.remove_filter "customField#{user_cf.id}"
    filters.add_filter_by(user_cf.name, 'is', [group.name], "customField#{user_cf.id}")

    wp_table.ensure_work_package_not_listed!(work_package_user, work_package_placeholder)
    wp_table.expect_work_package_listed(work_package_group)
  end
end
