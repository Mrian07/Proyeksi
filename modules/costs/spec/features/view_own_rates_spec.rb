

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'Only see your own rates', type: :feature, js: true do
  let(:project) { work_package.project }
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end
  let(:role) do
    FactoryBot.create :role, permissions: %i[view_own_hourly_rate
                                             view_work_packages
                                             view_work_packages
                                             view_own_time_entries
                                             view_own_cost_entries
                                             view_cost_rates
                                             log_costs]
  end
  let(:work_package) { FactoryBot.create :work_package }
  let(:wp_page) { ::Pages::FullWorkPackage.new(work_package) }
  let(:hourly_rate) do
    FactoryBot.create :default_hourly_rate, user: user,
                                            rate: 10.00
  end
  let(:time_entry) do
    FactoryBot.create :time_entry, user: user,
                                   work_package: work_package,
                                   project: project,
                                   hours: 1.00
  end
  let(:cost_type) do
    type = FactoryBot.create :cost_type, name: 'Translations'
    FactoryBot.create :cost_rate, cost_type: type,
                                  rate: 7.00
    type
  end
  let(:cost_entry) do
    FactoryBot.create :cost_entry, work_package: work_package,
                                   project: project,
                                   units: 2.00,
                                   cost_type: cost_type,
                                   user: user
  end
  let(:other_role) { FactoryBot.create :role, permissions: [] }
  let(:other_user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: other_role
  end
  let(:other_hourly_rate) do
    FactoryBot.create :default_hourly_rate, user: other_user,
                                            rate: 11.00
  end
  let(:other_time_entry) do
    FactoryBot.create :time_entry, user: other_user,
                                   hours: 3.00,
                                   project: project,
                                   work_package: work_package
  end
  let(:other_cost_entry) do
    FactoryBot.create :cost_entry, work_package: work_package,
                                   project: project,
                                   units: 5.00,
                                   user: other_user,
                                   cost_type: cost_type
  end

  before do
    login_as(user)

    work_package
    hourly_rate
    time_entry
    cost_entry
    other_hourly_rate
    other_user
    other_time_entry
    other_cost_entry

    wp_page.visit!
    wp_page.ensure_page_loaded
  end

  it 'only displays own entries and rates' do
    # All the values do not include the entries made by the other user
    wp_page.expect_attributes spent_time: '1 h',
                              costs_by_type: '2 Translations',
                              overall_costs: '24.00 EUR',
                              labor_costs: '10.00 EUR',
                              material_costs: '14.00 EUR'
  end
end
