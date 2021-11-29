

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Project status widget on dashboard', type: :feature, js: true do
  let!(:project) { FactoryBot.create :project, status: project_status }
  let!(:project_status) do
    FactoryBot.create :project_status
  end

  let(:read_only_permissions) do
    %i[view_dashboards manage_dashboards]
  end

  let(:editing_permissions) do
    %i[view_dashboards
       manage_dashboards
       edit_project]
  end

  let(:read_only_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: read_only_permissions)
  end

  let(:editing_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: editing_permissions)
  end

  let(:dashboard_page) do
    Pages::Dashboard.new(project)
  end

  def add_project_status_widget
    dashboard_page.visit!
    dashboard_page.add_widget(1, 1, :within, "Project status")

    dashboard_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')
  end

  before do
    login_as current_user
    add_project_status_widget
  end

  context 'without editing permissions' do
    let(:current_user) { read_only_user }

    it 'can add the widget, but not edit the status' do
      # As the user lacks the manage_public_queries and save_queries permission, no other widget is present
      status_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

      within(status_widget.area) do
        # The description is visible
        expect(page)
          .to have_content('ON TRACK')

        expect(page)
          .to have_content(project_status.explanation)

        # The status selector does not open
        field = EditField.new(dashboard_page, 'status')
        field.expect_read_only
        field.activate! expect_open: false

        # The explanation is not editable
        field = TextEditorField.new(dashboard_page, 'statusExplanation')
        field.expect_read_only
        field.activate! expect_open: false
      end
    end
  end

  context 'with editing permissions' do
    let(:current_user) { editing_user }

    it 'can edit the status and its explanation' do
      # As the user lacks the manage_public_queries and save_queries permission, no other widget is present
      status_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

      within(status_widget.area) do
        # Open status selector
        field = ProjectStatusField.new(dashboard_page, 'status')
        field.activate!
        sleep(0.1)

        # Change the value
        field.set_to('AT RISK')

        # The edit field is toggled and the value saved.
        expect(page).to have_content('AT RISK')
        expect(page).to have_selector(field.selector)
        expect(page).not_to have_selector(field.input_selector)

        # Unset the project status
        field.activate!
        sleep(0.1)
        field.set_to('NOT SET')

        # The edit field is toggled and the value saved.
        expect(page).to have_content('NOT SET')
        expect(page).to have_selector(field.selector)
        expect(page).not_to have_selector(field.input_selector)

        # Open explanation field
        field = TextEditorField.new dashboard_page, 'statusExplanation'
        field.activate!
        sleep(0.1)

        # Change the value
        field.expect_value(project_status.explanation)
        field.set_value 'A completely new explanation which is super cool.'
        field.save!

        # The edit field is toggled and the value saved.
        expect(page).to have_content('A completely new explanation which is super cool.')
        expect(page).to have_selector(field.selector)
        expect(page).not_to have_selector(field.input_selector)
      end
    end
  end
end
