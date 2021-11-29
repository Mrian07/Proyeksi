

require 'spec_helper'

describe 'List custom fields edit', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }

  before do
    login_as(admin)
    visit custom_fields_path(tab: :TimeEntryCustomField)
  end

  it 'can create and edit list custom fields (#37654)' do
    # Create CF
    click_on 'Create a new custom field'

    SeleniumHubWaiter.wait
    fill_in 'custom_field_name', with: 'My List CF'
    select 'List', from: 'custom_field_field_format'

    expect(page).to have_selector('input#custom_field_custom_options_attributes_0_value')
    fill_in 'custom_field_custom_options_attributes_0_value', with: 'A'

    click_on 'Save'

    # Expect correct values
    cf = CustomField.last
    expect(cf.name).to eq('My List CF')
    expect(cf.possible_values.map(&:value)).to eq %w(A)

    # Edit again
    SeleniumHubWaiter.wait
    page.find('a', text: 'My List CF').click

    expect(page).to have_selector('input#custom_field_custom_options_attributes_0_value')
    fill_in 'custom_field_custom_options_attributes_0_value', with: 'B'

    click_on 'Save'

    # Expect correct values again
    cf = CustomField.last
    expect(cf.name).to eq('My List CF')
    expect(cf.possible_values.map(&:value)).to eq %w(B)
  end
end
