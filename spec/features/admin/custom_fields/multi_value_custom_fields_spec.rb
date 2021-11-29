

require 'spec_helper'

describe 'Multi-value custom fields creation', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }

  def drag_and_drop(handle, to)
    scroll_to_element(handle)
    page
      .driver
      .browser
      .action
      .move_to(handle.native)
      .click_and_hold(handle.native)
      .perform

    scroll_to_element(to)
    page
      .driver
      .browser
      .action
      .move_to(to.native)
      .release
      .perform
  end

  before do
    login_as(admin)
    visit custom_fields_path
  end

  it 'can create and reorder custom field list values' do
    # Create CF
    click_on 'Create a new custom field'

    SeleniumHubWaiter.wait
    fill_in 'custom_field_name', with: 'My List CF'
    select 'List', from: 'custom_field_field_format'

    expect(page).to have_selector('input#custom_field_custom_options_attributes_0_value')
    fill_in 'custom_field_custom_options_attributes_0_value', with: 'A'

    # Add new row
    find('#add-custom-option').click
    SeleniumHubWaiter.wait
    expect(page).to have_selector('input#custom_field_custom_options_attributes_1_value')
    fill_in 'custom_field_custom_options_attributes_1_value', with: 'B'

    # Add new row
    find('#add-custom-option').click
    SeleniumHubWaiter.wait
    expect(page).to have_selector('input#custom_field_custom_options_attributes_2_value')
    fill_in 'custom_field_custom_options_attributes_2_value', with: 'C'

    click_on 'Save'

    # Edit again
    SeleniumHubWaiter.wait
    page.find('a', text: 'My List CF').click
    expect(page).to have_selector('input#custom_field_custom_options_attributes_0_value[value=A]')
    expect(page).to have_selector('input#custom_field_custom_options_attributes_1_value[value=B]')
    expect(page).to have_selector('input#custom_field_custom_options_attributes_2_value[value=C]')

    # Expect correct values
    cf = CustomField.last
    expect(cf.name).to eq('My List CF')
    expect(cf.possible_values.map(&:value)).to eq %w(A B C)

    # Drag and drop

    # We need to hack a target for where to drag the row to
    page.execute_script <<-JS
      jQuery('#custom-field-dragula-container')
        .append('<tr class="__drag_and_drop_end_of_list"><td colspan="4" style="height: 100px"></td></tr>');
    JS

    rows = page.all('tr.custom-option-row')
    expect(rows.length).to eq(3)
    drag_and_drop rows[0].find('.dragula-handle'), page.find('.__drag_and_drop_end_of_list')

    sleep 1

    page.execute_script <<-JS
      jQuery('.__drag_and_drop_end_of_list').remove()
    JS

    click_on 'Save'

    # Edit again
    expect(page).to have_selector('input#custom_field_custom_options_attributes_0_value[value=B]')
    expect(page).to have_selector('input#custom_field_custom_options_attributes_1_value[value=C]')
    expect(page).to have_selector('input#custom_field_custom_options_attributes_2_value[value=A]')

    cf.reload
    expect(cf.name).to eq('My List CF')
    expect(cf.possible_values.map(&:value)).to eq %w(B C A)
  end
end
