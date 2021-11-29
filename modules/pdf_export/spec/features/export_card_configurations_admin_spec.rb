
require 'spec_helper'

describe "export card configurations Admin", type: :feature, js: true do
  let(:user) { FactoryBot.create :admin }

  let!(:config1) { FactoryBot.create :export_card_configuration }
  let!(:config_default) { FactoryBot.create :default_export_card_configuration }
  let!(:config_active) { FactoryBot.create :active_export_card_configuration }

  before do
    login_as user
    visit pdf_export_export_card_configurations_path
  end

  it 'can manage export card configurations' do
    # INDEX
    expect(page).to have_text 'Config 1'
    expect(page).to have_text 'Default '
    expect(page).to have_text 'Config active'

    # CREATE
    click_on 'New Export Card Config'
    SeleniumHubWaiter.wait
    fill_in 'export_card_configuration_name', with: 'New config'
    fill_in 'export_card_configuration_per_page', with: '5'
    select 'landscape', from: 'export_card_configuration_orientation'
    valid_yaml = "groups:\n  rows:\n    row1:\n      columns:\n        id:\n          has_label: false"
    fill_in 'export_card_configuration_rows', with: valid_yaml
    click_on 'Create'
    expect(page).to have_text 'Successful creation.'

    # EDIT
    SeleniumHubWaiter.wait
    page.first('a', text: 'Config 1').click
    SeleniumHubWaiter.wait
    fill_in 'export_card_configuration_name', with: 'New name'
    fill_in 'export_card_configuration_per_page', with: '5'
    select 'portrait', from: 'export_card_configuration_orientation'
    fill_in 'export_card_configuration_rows', with: valid_yaml
    click_on 'Save'
    expect(page).to have_text 'Successful update.'

    expect(config1.reload.name).to eq 'New name'
    expect(config1.reload).to be_portrait

    # DEACTIVATE
    SeleniumHubWaiter.wait
    page.first('a', text: 'De-activate').click
    expect(page).to have_text 'Config successfully de-activated'

    # ACTIVATE
    SeleniumHubWaiter.wait
    page.first('a', text: 'Activate').click
    expect(page).to have_text 'Config successfully activated'
  end
end
