

require 'spec_helper'

describe 'Project templates', type: :feature, js: true do
  describe 'making project a template' do
    let(:project) { FactoryBot.create :project }
    shared_let(:admin) { FactoryBot.create :admin }

    before do
      login_as admin
    end

    it 'can make the project a template from settings' do
      visit project_settings_general_path(project)

      # Make a template
      find('.button', text: 'Set as template').click

      expect(page).to have_selector('.button', text: 'Remove from templates')
      project.reload
      expect(project).to be_templated

      # unset template
      find('.button', text: 'Remove from templates').click
      expect(page).to have_selector('.button', text: 'Set as template')

      project.reload
      expect(project).not_to be_templated
    end
  end

  describe 'instantiating templates' do
    let!(:template) do
      FactoryBot.create(:template_project, name: 'My template', enabled_module_names: %w[wiki work_package_tracking])
    end
    let!(:template_status) { FactoryBot.create(:project_status, project: template, explanation: 'source') }
    let!(:other_project) { FactoryBot.create(:project, name: 'Some other project') }
    let!(:work_package) { FactoryBot.create :work_package, project: template }
    let!(:wiki_page) { FactoryBot.create(:wiki_page_with_content, wiki: template.wiki) }

    let!(:role) do
      FactoryBot.create(:role, permissions: %i[view_project view_work_packages copy_projects add_subprojects add_project])
    end
    let!(:current_user) { FactoryBot.create(:user, member_in_projects: [template, other_project], member_through_role: role) }
    let(:status_field_selector) { 'ckeditor-augmented-textarea[textarea-selector="#project_status_explanation"]' }
    let(:status_description) { ::Components::WysiwygEditor.new status_field_selector }

    let(:name_field) { ::FormFields::InputFormField.new :name }
    let(:template_field) { ::FormFields::SelectFormField.new :use_template }
    let(:status_field) { ::FormFields::SelectFormField.new :status }
    let(:parent_field) { ::FormFields::SelectFormField.new :parent }

    before do
      login_as current_user
    end

    it 'can instantiate the project with the copy permission' do
      visit new_project_path

      name_field.set_value 'Foo bar'

      template_field.select_option 'My template'

      sleep 1

      # It keeps the name
      name_field.expect_value 'Foo bar'
      template_field.expect_selected 'My template'

      # Updates the identifier in advanced settings
      page.find('.op-fieldset--toggle', text: 'ADVANCED SETTINGS').click
      status_field.expect_selected 'ON TRACK'

      # It does not show the copy meta flags
      expect(page).to have_no_selector('[data-qa-field-name="copyMembers"]')
      expect(page).to have_no_selector('[data-qa-field-name="sendNotifications"]')

      # Update status to off track
      status_field.select_option 'Off track'
      parent_field.select_option other_project.name

      page.find('button:not([disabled])', text: 'Save').click

      expect(page).to have_content I18n.t(:label_copy_project)
      expect(page).to have_content I18n.t('js.job_status.generic_messages.in_queue')

      # Email notification should be sent
      perform_enqueued_jobs

      mail = ActionMailer::Base
        .deliveries
        .detect { |mail| mail.subject == 'Created project Foo bar' }

      expect(mail).not_to be_nil

      expect(page).to have_current_path /\/projects\/foo-bar\/?/, wait: 20

      project = Project.find_by identifier: 'foo-bar'
      expect(project.name).to eq 'Foo bar'
      expect(project).not_to be_templated
      expect(project.users.first).to eq current_user
      expect(project.enabled_module_names.sort).to eq(template.enabled_module_names.sort)

      wp_source = template.work_packages.first.attributes.except(*%w[id author_id project_id updated_at created_at])
      wp_target = project.work_packages.first.attributes.except(*%w[id author_id project_id updated_at created_at])
      expect(wp_source).to eq(wp_target)

      wiki_source = template.wiki.pages.first
      wiki_target = project.wiki.pages.first
      expect(wiki_source.title).to eq(wiki_target.title)
      expect(wiki_source.content.text).to eq(wiki_target.content.text)
    end
  end
end
