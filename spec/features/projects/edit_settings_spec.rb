

require 'spec_helper'

describe 'Projects', 'editing settings', type: :feature, js: true do
  let(:name_field) { ::FormFields::InputFormField.new :name }
  let(:parent_field) { ::FormFields::SelectFormField.new :parent }
  let(:permissions) { %i(edit_project) }

  current_user do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  shared_let(:project) do
    FactoryBot.create(:project, name: 'Foo project', identifier: 'foo-project')
  end

  it 'hides the field whose functionality is presented otherwise' do
    visit project_settings_general_path(project.id)

    expect(page).to have_no_text :all, 'Active'
    expect(page).to have_no_text :all, 'Identifier'
  end

  describe 'identifier edit', js: false do
    it 'updates the project identifier' do
      visit projects_path
      click_on project.name
      SeleniumHubWaiter.wait
      click_on 'Project settings'
      SeleniumHubWaiter.wait
      click_on 'Change identifier'

      expect(page).to have_content "Change the project's identifier"
      expect(page).to have_current_path '/projects/foo-project/identifier'

      fill_in 'project[identifier]', with: 'foo-bar'
      click_on 'Update'

      expect(page).to have_content 'Successful update.'
      expect(page)
        .to have_current_path '/projects/foo-bar/settings/general'
      expect(Project.first.identifier).to eq 'foo-bar'
    end

    it 'displays error messages on invalid input' do
      visit project_identifier_path(project)

      fill_in 'project[identifier]', with: 'FOOO'
      click_on 'Update'

      expect(page).to have_content 'Identifier is invalid.'
      expect(page).to have_current_path '/projects/foo-project/identifier'
    end
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

    it 'shows optional and required custom fields for edit without a separation' do
      project.custom_field_values.last.value = 'FOO'
      project.save!

      visit project_settings_general_path(project.id)

      expect(page).to have_text 'Optional Foo'
      expect(page).to have_text 'Required Foo'
    end
  end

  context 'with a length restricted custom field' do
    let!(:required_custom_field) do
      FactoryBot.create(:string_project_custom_field,
                        name: 'Foo',
                        type: ProjectCustomField,
                        min_length: 1,
                        max_length: 2,
                        is_for_all: true)
    end
    let(:foo_field) { ::FormFields::InputFormField.new required_custom_field }

    it 'shows the errors of that field when saving (Regression #33766)' do
      visit project_settings_general_path(project.id)

      expect(page).to have_content 'Foo'

      # Enter something too long
      foo_field.set_value '1234'

      # It should cut of that remaining value
      foo_field.expect_value '12'

      click_button 'Save'

      expect(page).to have_text 'Successful update.'
    end
  end

  context 'with a multi-select custom field' do
    include_context 'ng-select-autocomplete helpers'

    let!(:list_custom_field) { FactoryBot.create(:list_project_custom_field, name: 'List CF', multi_value: true) }
    let(:form_field) { ::FormFields::SelectFormField.new list_custom_field }

    it 'can select multiple values' do
      visit project_settings_general_path(project.id)

      form_field.select_option 'A', 'B'

      click_on 'Save'

      expect(page).to have_content 'Successful update.'

      form_field.expect_selected 'A', 'B'

      cvs = project.reload.custom_value_for(list_custom_field)
      expect(cvs.count).to eq 2
      expect(cvs.map(&:typed_value)).to contain_exactly 'A', 'B'
    end
  end

  context 'with a date custom field' do
    let!(:date_custom_field) { FactoryBot.create(:date_project_custom_field, name: 'Date') }
    let(:form_field) { ::FormFields::InputFormField.new date_custom_field }

    it 'can save and remove the date (Regression #37459)' do
      visit project_settings_general_path(project.id)

      form_field.set_value '2021-05-26'
      form_field.send_keys :escape

      click_on 'Save'

      expect(page).to have_content 'Successful update.'

      form_field.expect_value '2021-05-26'

      cv = project.reload.custom_value_for(date_custom_field)
      expect(cv.typed_value).to eq '2021-05-26'.to_date
    end
  end

  context 'with a user not allowed to see the parent project' do
    include_context 'ng-select-autocomplete helpers'

    let(:parent_project) { FactoryBot.create(:project) }
    let(:parent_field) { ::FormFields::SelectFormField.new 'parent' }

    before do
      project.update_attribute(:parent, parent_project)
    end

    it 'can update the project without destroying the relation to the parent' do
      visit project_settings_general_path(project.id)

      fill_in 'Name', with: 'New project name'

      parent_field.expect_selected I18n.t(:'api_v3.undisclosed.parent')

      click_on 'Save'

      expect(page).to have_content 'Successful update.'

      project.reload

      expect(project.name)
        .to eql 'New project name'

      expect(project.parent)
        .to eql parent_project
    end
  end
end