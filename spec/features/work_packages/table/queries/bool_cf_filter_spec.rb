

require 'spec_helper'

describe 'Work package filtering by bool custom field', js: true do
  let(:project) { FactoryBot.create :project }
  let(:type) { project.types.first }
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }
  let(:filters) { ::Components::WorkPackages::Filters.new }
  let!(:bool_cf) do
    FactoryBot.create(:bool_wp_custom_field).tap do |cf|
      type.custom_fields << cf
      project.work_package_custom_fields << cf
    end
  end
  let(:role) { FactoryBot.create(:role, permissions: %i[view_work_packages save_queries]) }
  let!(:work_package_true) do
    FactoryBot.create(:work_package,
                      type: type,
                      project: project).tap do |wp|
      wp.custom_field_values = { bool_cf.id => true }
      wp.save!
    end
  end
  let!(:work_package_false) do
    FactoryBot.create(:work_package,
                      type: type,
                      project: project).tap do |wp|
      wp.custom_field_values = { bool_cf.id => false }
      wp.save!
    end
  end
  let!(:work_package_without) do
    # Has no custom field value set
    FactoryBot.create(:work_package,
                      type: type,
                      project: project)
  end
  let!(:work_package_other_type) do
    # Does not have the custom field at all
    FactoryBot.create(:work_package,
                      type: project.types.last,
                      project: project)
  end

  current_user do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i[view_work_packages save_queries]
  end

  it 'shows the work package matching the bool cf filter' do
    wp_table.visit!
    wp_table.expect_work_package_listed(work_package_true, work_package_false, work_package_without, work_package_other_type)

    filters.open

    # Add filtering by bool custom field which defaults to false
    filters.add_filter(bool_cf.name)

    # Turn the added filter to the "true" value.
    # Ideally this would be the default.
    page.find("#div-values-customField#{bool_cf.id} label").click

    wp_table.ensure_work_package_not_listed!(work_package_false, work_package_without, work_package_other_type)
    wp_table.expect_work_package_listed(work_package_true)

    wp_table.save_as('Saved query')

    wp_table.expect_and_dismiss_toaster(message: 'Successful creation.')

    # Revisit query
    wp_table.visit_query Query.last
    wp_table.ensure_work_package_not_listed!(work_package_false, work_package_without, work_package_other_type)
    wp_table.expect_work_package_listed(work_package_true)

    filters.open

    # Inverting the filter
    page.find("#div-values-customField#{bool_cf.id} label").click

    wp_table.ensure_work_package_not_listed!(work_package_true)
    wp_table.expect_work_package_listed(work_package_false, work_package_without, work_package_other_type)
  end
end
