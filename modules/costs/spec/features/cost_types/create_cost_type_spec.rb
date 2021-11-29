

require 'spec_helper'

describe 'creating a cost type', type: :feature, js: true do
  let!(:user) { FactoryBot.create :admin }
  let!(:cost_type) do
    type = FactoryBot.create :cost_type, name: 'Translations'
    FactoryBot.create :cost_rate, cost_type: type, rate: 1.00
    type
  end

  before do
    login_as user
  end

  it 'can create a cost type' do
    visit "/cost_types/new"

    fill_in 'cost_type_name', with: 'Test day rate'
    fill_in 'cost_type_unit', with: 'dayUnit'
    fill_in 'cost_type_unit_plural', with: 'dayUnitPlural'
    fill_in 'cost_type_new_rate_attributes_0_rate', with: '1,000.25'

    sleep 1

    scroll_to_and_click(find('button.-with-icon.icon-checkmark'))

    expect_angular_frontend_initialized
    expect(page).to have_selector '.generic-table', wait: 10

    cost_type_row = find('tr', text: 'Test day rate')

    expect(cost_type_row).to have_selector('td a', text: 'Test day rate')
    expect(cost_type_row).to have_selector('td', text: 'dayUnit')
    expect(cost_type_row).to have_selector('td', text: 'dayUnitPlural')
    expect(cost_type_row).to have_selector('td.currency', text: '1,000.25')

    cost_type = CostType.last
    expect(cost_type.name).to eq 'Test day rate'
    cost_rate = cost_type.rates.last
    expect(cost_rate.rate).to eq 1000.25
  end

  context 'with german locale' do
    let(:user) { FactoryBot.create(:admin, language: :de) }

    it 'creates the entry with german number separators' do
      visit "/cost_types/new"

      fill_in 'cost_type_name', with: 'Test day rate'
      fill_in 'cost_type_unit', with: 'dayUnit'
      fill_in 'cost_type_unit_plural', with: 'dayUnitPlural'
      fill_in 'cost_type_new_rate_attributes_0_rate', with: '1.000,25'

      sleep 1

      scroll_to_and_click(find('button.-with-icon.icon-checkmark'))

      expect_angular_frontend_initialized
      expect(page).to have_selector '.generic-table', wait: 10

      cost_type_row = find('tr', text: 'Test day rate')

      expect(cost_type_row).to have_selector('td a', text: 'Test day rate')
      expect(cost_type_row).to have_selector('td', text: 'dayUnit')
      expect(cost_type_row).to have_selector('td', text: 'dayUnitPlural')
      expect(cost_type_row).to have_selector('td.currency', text: '1.000,25')

      cost_type = CostType.last
      expect(cost_type.name).to eq 'Test day rate'
      cost_rate = cost_type.rates.last
      expect(cost_rate.rate).to eq 1000.25
    end
  end
end
