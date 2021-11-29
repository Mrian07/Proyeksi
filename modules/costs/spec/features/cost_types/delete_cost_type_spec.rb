

require 'spec_helper'

describe 'deleting a cost type', type: :feature, js: true do
  let!(:user) { FactoryBot.create :admin }
  let!(:cost_type) do
    type = FactoryBot.create :cost_type, name: 'Translations'
    FactoryBot.create :cost_rate, cost_type: type, rate: 1.00
    type
  end

  before do
    login_as user
  end

  it 'can delete the cost type' do
    visit cost_types_path

    within("#delete_cost_type_#{cost_type.id}") do
      scroll_to_and_click(find('button.submit_cost_type'))
    end

    # Expect no results if not locked
    expect_angular_frontend_initialized
    expect(page).to have_selector '.generic-table--no-results-container', wait: 10

    SeleniumHubWaiter.wait
    # Show locked
    find('#include_deleted').set true
    click_on 'Apply'

    # Expect no results if not locked
    expect(page).to have_text I18n.t(:label_locked_cost_types)

    expect(page).to have_selector('.restore_cost_type')
    expect(page).to have_selector('.cost-types--list-deleted td', text: 'Translations')
  end
end
