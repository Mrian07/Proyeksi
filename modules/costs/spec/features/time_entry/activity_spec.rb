

require 'spec_helper'

describe 'Time entry activity', type: :feature do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:project) { FactoryBot.create(:project) }

  before do
    login_as(admin)
  end

  it 'supports CRUD' do
    visit enumerations_path

    page.all('.wp-inline-create--add-link[title="New enumeration value"]').first.click

    fill_in 'Name', with: 'A new activity'
    click_on('Create')

    expect(page.current_path)
      .to eql enumerations_path

    expect(page)
      .to have_content('A new activity')

    visit project_settings_general_path(project)

    click_on "Time tracking activities"

    expect(page)
      .to have_field('A new activity', checked: true)

    uncheck 'A new activity'

    click_on 'Save'

    expect(page)
      .to have_content "Successful update."

    expect(page)
      .to have_field('A new activity', checked: false)
  end
end
