

require 'spec_helper'

describe 'Project attribute help texts', type: :feature, js: true do
  let(:project) { FactoryBot.create :project }

  let(:instance) do
    FactoryBot.create :project_help_text,
                      attribute_name: :status,
                      help_text: 'Some **help text** for status.'
    FactoryBot.create :project_help_text,
                      attribute_name: :description,
                      help_text: 'Some **help text** for description.'
  end

  let(:grid) do
    grid = FactoryBot.create :grid
    grid.widgets << FactoryBot.create(:grid_widget,
                                      identifier: 'project_status',
                                      options: { 'name' => 'Project status' },
                                      start_row: 1,
                                      end_row: 2,
                                      start_column: 1,
                                      end_column: 1)
  end

  let(:modal) { Components::AttributeHelpTextModal.new(instance) }
  let(:wp_page) { Pages::FullWorkPackage.new work_package }

  before do
    login_as user
    project
    instance
  end

  shared_examples 'allows to view help texts' do
    it 'shows an indicator for whatever help text exists' do
      visit project_path(project)

      within '#menu-sidebar' do
        click_link "Overview"
      end

      expect(page).to have_selector('[data-qa-selector="op-widget-box--header"] .help-text--entry', wait: 10)

      # Open help text modal
      modal.open!
      expect(modal.modal_container).to have_selector('strong', text: 'help text')
      modal.expect_edit(admin: user.admin?)

      modal.close!
    end
  end

  describe 'as admin' do
    let(:user) { FactoryBot.create :admin }
    it_behaves_like 'allows to view help texts'

    it 'shows the help text on the project create form' do
      visit new_project_path

      page.find('.op-fieldset--legend', text: 'ADVANCED SETTINGS').click

      expect(page).to have_selector('.op-form-field--label attribute-help-text', wait: 10)

      # Open help text modal
      modal.open!
      expect(modal.modal_container).to have_selector('strong', text: 'help text')
      modal.expect_edit(admin: user.admin?)

      modal.close!
    end
  end

  describe 'as regular user' do
    let(:view_role) do
      FactoryBot.create :role, permissions: [:view_project]
    end
    let(:user) do
      FactoryBot.create :user,
                        member_in_project: project,
                        member_through_role: view_role
    end

    it_behaves_like 'allows to view help texts'
  end
end
