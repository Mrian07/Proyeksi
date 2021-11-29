

require 'spec_helper'

describe 'Projects', 'creation', type: :feature, js: true do
  let(:name_field) { ::FormFields::InputFormField.new :name }

  current_user { FactoryBot.create(:admin) }

  shared_let(:project) { FactoryBot.create(:project, name: 'Foo project', identifier: 'foo-project') }

  before do
    visit projects_path
  end

  it 'can create a project' do
    click_on 'New project'

    name_field.set_value 'Foo bar'
    click_button 'Save'

    sleep 1

    expect(page).to have_content 'Foo bar'
    expect(page).to have_current_path /\/projects\/foo-bar\/?/
  end

  it 'does not create a project with an already existing identifier' do
    click_on 'New project'

    name_field.set_value 'Foo project'
    click_on 'Save'

    expect(page).to have_current_path /\/projects\/foo-project-1\/?/

    project = Project.last
    expect(project.identifier).to eq 'foo-project-1'
  end

  context 'with a multi-select custom field' do
    let!(:list_custom_field) { FactoryBot.create(:list_project_custom_field, name: 'List CF', multi_value: true) }
    let(:list_field) { ::FormFields::SelectFormField.new list_custom_field }

    it 'can create a project' do
      click_on 'New project'

      name_field.set_value 'Foo bar'

      find('.op-fieldset--toggle', text: 'ADVANCED SETTINGS').click

      list_field.select_option 'A', 'B'

      click_button 'Save'

      expect(page).to have_current_path /\/projects\/foo-bar\/?/
      expect(page).to have_content 'Foo bar'

      project = Project.last
      expect(project.name).to eq 'Foo bar'
      cvs = project.custom_value_for(list_custom_field)
      expect(cvs.count).to eq 2
      expect(cvs.map(&:typed_value)).to contain_exactly 'A', 'B'
    end
  end

  it 'hides the active field and the identifier' do
    visit new_project_path

    find('.op-fieldset--toggle', text: 'ADVANCED SETTINGS').click

    expect(page).to have_no_content 'Active'
    expect(page).to have_no_content 'Identifier'
  end

  context 'with optional and required custom fields' do
    let!(:optional_custom_field) do
      FactoryBot.create(:custom_field, name: 'Optional Foo',
                        type: ProjectCustomField,
                        is_for_all: true)
    end
    let!(:required_custom_field) do
      FactoryBot.create(:custom_field, name: 'Required Foo',
                        type: ProjectCustomField,
                        is_for_all: true,
                        is_required: true)
    end

    it 'seperates optional and required custom fields for new' do
      visit new_project_path

      expect(page).to have_content 'Required Foo'

      click_on 'Advanced settings'

      within('.op-fieldset') do
        expect(page).to have_text 'Optional Foo'
        expect(page).to have_no_text 'Required Foo'
      end
    end
  end
end
