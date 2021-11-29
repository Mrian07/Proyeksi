

require 'spec_helper'

feature 'version edit', type: :feature do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: version.project,
                      member_with_permissions: %i[manage_versions view_work_packages])
  end
  let(:version) { FactoryBot.create(:version) }
  let(:new_version_name) { 'A new version name' }

  before do
    login_as(user)
  end

  scenario 'edit a version' do
    # from the version show page
    visit version_path(version)

    within '.toolbar' do
      click_link 'Edit'
    end

    fill_in 'Name', with: new_version_name

    click_button 'Save'

    expect(page)
      .to have_current_path(version_path(version))
    expect(page)
      .to have_content new_version_name
  end
end
