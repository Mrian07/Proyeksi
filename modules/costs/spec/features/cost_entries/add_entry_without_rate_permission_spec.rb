

require_relative '../../spec_helper'

describe 'Create cost entry without rate permissions', type: :feature, js: true do
  shared_let(:type_task) { FactoryBot.create(:type_task) }
  shared_let(:status) { FactoryBot.create(:status, is_default: true) }
  shared_let(:priority) { FactoryBot.create(:priority, is_default: true) }
  shared_let(:project) do
    FactoryBot.create(:project, types: [type_task])
  end
  shared_let(:role) do
    FactoryBot.create :role, permissions: %i[view_work_packages
                                             log_costs
                                             view_cost_entries]
  end
  shared_let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end

  shared_let(:cost_type) do
    type = FactoryBot.create :cost_type, name: 'A', unit: 'A single', unit_plural: 'A plural'
    FactoryBot.create :cost_rate, cost_type: type, rate: 1.00
    type
  end

  shared_let(:work_package) { FactoryBot.create :work_package, project: project, status: status, type: type_task }
  shared_let(:full_view) { ::Pages::FullWorkPackage.new(work_package, project) }

  before do
    login_as user
  end

  it 'can create the item without seeing the costs' do
    full_view.visit!
    # Go to add cost entry page
    SeleniumHubWaiter.wait
    find('#action-show-more-dropdown-menu .button').click
    find('.menu-item', text: 'Log unit costs').click

    SeleniumHubWaiter.wait
    # Set single value, should update suffix
    select 'A', from: 'cost_entry_cost_type_id'
    fill_in 'cost_entry_units', with: '1'
    expect(page).to have_selector('#cost_entry_unit_name', text: 'A single')
    expect(page).to have_no_selector('#cost_entry_costs')

    click_on 'Save'

    # Expect correct costs
    expect(page).to have_selector('.flash.notice', text: I18n.t(:notice_cost_logged_successfully))
    entry = CostEntry.last
    expect(entry.cost_type_id).to eq(cost_type.id)
    expect(entry.units).to eq(1.0)
    expect(entry.costs).to eq(1.0)
    expect(entry.real_costs).to eq(1.0)
  end
end
