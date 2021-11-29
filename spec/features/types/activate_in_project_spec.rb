

require 'spec_helper'
require 'support/pages/custom_fields'

describe 'types', js: true do
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i(edit_project manage_types add_work_packages view_work_packages)
  end
  let!(:active_type) { FactoryBot.create(:type) }
  let!(:type) { FactoryBot.create(:type) }
  let!(:project) { FactoryBot.create(:project, types: [active_type]) }
  let(:project_settings_page) { Pages::Projects::Settings.new(project) }
  let(:work_packages_page) { Pages::WorkPackagesTable.new(project) }

  before do
    login_as(user)
  end

  it 'is only visible in the project if it has been activated' do
    # the currently active types are available for work package creation
    work_packages_page.visit!

    work_packages_page.expect_type_available_for_create(active_type)
    work_packages_page.expect_type_not_available_for_create(type)

    project_settings_page.visit_tab!('types')

    expect(page)
      .to have_unchecked_field(type.name)
    expect(page)
      .to have_checked_field(active_type.name)

    # switch enabled types
    check(type.name)
    uncheck(active_type.name)

    project_settings_page.save!

    expect(page)
      .to have_checked_field(type.name)
    expect(page)
      .to have_unchecked_field(active_type.name)

    # the newly activated types are available for work package creation
    # disabled ones are not
    work_packages_page.visit!

    work_packages_page.expect_type_available_for_create(type)
    work_packages_page.expect_type_not_available_for_create(active_type)
  end
end
