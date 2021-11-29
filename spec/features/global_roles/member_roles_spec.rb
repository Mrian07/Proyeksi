

require 'spec_helper'

describe 'Global role: Unchanged Member Roles', type: :feature, js: true do
  let(:admin) { FactoryBot.create(:admin) }
  let(:project) { FactoryBot.create :project }
  let!(:role) { FactoryBot.create(:role, name: 'MemberRole1') }
  let!(:global_role) { FactoryBot.create(:global_role, name: 'GlobalRole1') }

  let(:members) { ::Pages::Members.new project.identifier }

  before do
    login_as(admin)
  end

  scenario 'Global Rights Modules do not exist as Project -> Settings -> Modules' do
    # Scenario: Global Roles should not be displayed as assignable project roles
    # Given there is 1 project with the following:
    # | Name       | projectname |
    # | Identifier | projectid   |
    #   And there is a global role "GlobalRole1"
    # And there is a role "MemberRole1"
    # And I am already admin
    # When I go to the members page of the project "projectid"
    visit project_members_path(project)
    # And I click "Add member"
    members.open_new_member!

    # Then I should see "MemberRole1" within "#member_role_ids"
    members.expect_role 'MemberRole1'

    # Then I should not see "GlobalRole1" within "#member_role_ids"
    members.expect_role 'GlobalRole1', present: false
  end
end
