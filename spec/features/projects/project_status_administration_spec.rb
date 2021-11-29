

require 'spec_helper'

describe 'Projects status administration', type: :feature, js: true do
  include_context 'ng-select-autocomplete helpers'

  let(:current_user) do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:global_member,
                        principal: u,
                        roles: [FactoryBot.create(:global_role, permissions: global_permissions)])
    end
  end
  let(:global_permissions) { [:add_project] }
  let(:project_permissions) { [:edit_project] }
  let!(:project_role) do
    FactoryBot.create(:role, permissions: project_permissions).tap do |r|
      allow(Setting)
        .to receive(:new_project_user_role_id)
        .and_return(r.id.to_s)
    end
  end
  let(:status_description) { Components::WysiwygEditor.new('[data-qa-field-name="statusExplanation"]') }

  let(:name_field) { ::FormFields::InputFormField.new :name }
  let(:status_field) { ::FormFields::SelectFormField.new :status }

  before do
    login_as current_user
  end

  it 'allows setting the status on project creation' do
    visit new_project_path

    # Create the project with status
    click_button 'Advanced settings'

    name_field.set_value 'New project'
    status_field.select_option 'On track'

    status_description.set_markdown 'Everything is fine at the start'
    status_description.expect_supports_no_macros

    click_button 'Save'

    expect(page).to have_current_path /projects\/new-project\/?/

    # Check that the status has been set correctly
    visit project_settings_general_path(project_id: 'new-project')

    status_field.expect_selected 'ON TRACK'
    status_description.expect_value 'Everything is fine at the start'

    status_field.select_option 'Off track'
    status_description.set_markdown 'Oh no'

    click_button 'Save'

    status_field.expect_selected 'OFF TRACK'
    status_description.expect_value 'Oh no'
  end
end
