

require_relative '../../spec_helper'

describe 'BIM Revit Add-in navigation spec',
         type: :feature,
         with_config: { edition: 'bim' },
         js: true,
         driver: :chrome_revit_add_in do
  let(:project) { FactoryBot.create :project, enabled_module_names: %i[bim work_package_tracking] }
  let!(:work_package) { FactoryBot.create(:work_package, project: project) }
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_ifc_models manage_ifc_models add_work_packages edit_work_packages view_work_packages])
  end
  let(:wp_table) { ::Pages::WorkPackagesTable.new(project) }

  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  let(:model_page) { ::Pages::IfcModels::ShowDefault.new(project) }

  before do
    login_as(user)
    model_page.visit!
  end

  it 'click on refresh button reloads information' do
    # Context BCF cards view
    model_page.page_shows_a_filter_button(true)
    work_package.update_attribute(:subject, 'Refreshed while in cards view')
    model_page.click_refresh_button
    expect(page).to have_text('Refreshed while in cards view')

    # Context BCF full view
    model_page.click_info_icon(work_package)
    work_package.update_attribute(:subject, 'Refreshed while in full view')
    model_page.click_refresh_button
    expect(page).to have_text('Refreshed while in full view')
  end
end
