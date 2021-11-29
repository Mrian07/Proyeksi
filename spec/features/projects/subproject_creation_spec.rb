

require 'spec_helper'

describe 'Subproject creation', type: :feature, js: true do
  let(:name_field) { ::FormFields::InputFormField.new :name }
  let(:parent_field) { ::FormFields::SelectFormField.new :parent }
  let(:add_subproject_role) { FactoryBot.create(:role, permissions: %i[edit_project add_subprojects]) }
  let(:view_project_role) { FactoryBot.create(:role, permissions: %i[edit_project]) }
  let!(:parent_project) do
    FactoryBot.create(:project,
                      name: 'Foo project',
                      members: { current_user => add_subproject_role })
  end
  let!(:other_project) do
    FactoryBot.create(:project,
                      name: 'Other project',
                      members: { current_user => view_project_role })
  end

  current_user do
    FactoryBot.create(:user)
  end

  before do
    visit project_settings_general_path(parent_project)
  end

  it 'can create a subproject' do
    click_link 'Subproject'

    name_field.set_value 'Foo child'
    parent_field.expect_required
    # The other project is not a valid parent since the user is lacking
    # the add_subproject permission therein.
    parent_field.expect_no_option(other_project.name)
    parent_field.expect_selected parent_project.name

    click_button 'Save'

    expect(page).to have_current_path /\/projects\/foo-child\/?/

    child = Project.last
    expect(child.identifier).to eq 'foo-child'
    expect(child.parent).to eq parent_project
  end
end
