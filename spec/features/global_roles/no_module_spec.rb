

require 'spec_helper'
require_relative './mock_global_permissions'

describe 'Global role: No module', type: :feature, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create :project }
  let!(:role) { FactoryBot.create(:role) }

  before do
    login_as(admin)
  end

  scenario 'Global Rights Modules do not exist as Project -> Settings -> Modules' do
    # Scenario:
    # Given there is the global permission "glob_test" of the module "global"
    mock_global_permissions [['global_perm1', { project_module: :global }]]

    # And there is 1 project with the following:
    # | name       | test |
    # | identifier | test |
    #   And I am already admin
    # When I go to the modules tab of the settings page for the project "test"
    #                                                     Then I should not see "Global"
    visit project_settings_modules_path(project)

    expect(page).to have_text 'Activity'
    expect(page).to have_no_text 'Foo'
  end
end
