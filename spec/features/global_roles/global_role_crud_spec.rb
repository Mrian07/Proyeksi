

require 'spec_helper'
require_relative './mock_global_permissions'

describe 'Global role: Global role CRUD', type: :feature, js: true do
  # Scenario: Global Role creation
  # Given there is the global permission "glob_test" of the module "global_group"
  before do
    mock_global_permissions [['glob_test', { project_module: 'global_group' }]]
    login_as(current_user)
  end

  # And I am already admin
  let(:current_user) { FactoryBot.create :admin }

  it 'can create global role with that perm' do
    # When I go to the new page of "Role"
    visit new_role_path
    # Then I should not see block with "#global_permissions"
    expect(page).to have_no_selector('#global_permissions', visible: true)
    # When I check "Global Role"
    check 'Global Role'
    # Then I should see block with "#global_permissions"
    expect(page).to have_selector('#global_permissions', visible: true)
    # And I should see "Global group"
    expect(page).to have_text 'GLOBAL GROUP'
    # And I should see "Glob test"
    expect(page).to have_text 'Glob test'
    # And I should not see "Issues can be assigned to this role"
    expect(page).to have_no_text 'Issues can be assigned to this role'
    # When I fill in "Name" with "Manager"
    fill_in 'Name', with: 'Manager'
    # And I click on "Create"
    click_on 'Create'
    # Then I should see "Successful creation."
    expect(page).to have_text 'Successful creation.'
  end
end
