

require 'spec_helper'

require_relative '../../support/pages/my/page'

describe 'Arbitrary WorkPackage query table widget on my page', type: :feature, js: true, with_mail: false do
  let!(:type) { FactoryBot.create :type }
  let!(:other_type) { FactoryBot.create :type }
  let!(:priority) { FactoryBot.create :default_priority }
  let!(:project) { FactoryBot.create :project, types: [type] }
  let!(:other_project) { FactoryBot.create :project, types: [type] }
  let!(:open_status) { FactoryBot.create :default_status }
  let!(:type_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      author: user,
                      responsible: user
  end
  let!(:other_type_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: other_type,
                      author: user,
                      responsible: user
  end

  let(:permissions) { %i[view_work_packages add_work_packages save_queries] }

  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:my_page) do
    Pages::My::Page.new
  end

  let(:modal) { ::Components::WorkPackages::TableConfigurationModal.new }
  let(:filters) { ::Components::WorkPackages::TableConfiguration::Filters.new }
  let(:columns) { ::Components::WorkPackages::Columns.new }

  before do
    login_as user

    my_page.visit!
  end

  context 'with the permission to save queries' do
    it 'can add the widget and see the work packages of the filtered for types' do
      sleep(0.5)

      my_page.add_widget(1, 2, :column, "Work packages table")

      # Actually there are two success messages displayed currently. One for the grid getting updated and one
      # for the query assigned to the new widget being created. A user will not notice it but the automated
      # browser can get confused. Therefore we wait.
      sleep(1)

      my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

      filter_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(3)')
      filter_area.expect_to_span(1, 2, 2, 3)

      # At the beginning, the default query is displayed
      expect(filter_area.area)
        .to have_selector('.subject', text: type_work_package.subject)

      expect(filter_area.area)
        .to have_selector('.subject', text: other_type_work_package.subject)

      # User has the ability to modify the query

      filter_area.configure_wp_table
      modal.switch_to('Filters')
      filters.expect_filter_count(2)
      filters.add_filter_by('Type', 'is', type.name)
      modal.save

      filter_area.configure_wp_table
      modal.switch_to('Columns')
      columns.assume_opened
      columns.remove 'Subject'

      expect(filter_area.area)
        .to have_selector('.id', text: type_work_package.id)

      # as the Subject column is disabled
      expect(filter_area.area)
        .to have_no_selector('.subject', text: type_work_package.subject)

      # As other_type is filtered out
      expect(filter_area.area)
        .to have_no_selector('.id', text: other_type_work_package.id)

      scroll_to_element(filter_area.area)
      within filter_area.area do
        input = find('.editable-toolbar-title--input')
        input.set('My WP Filter')
        input.native.send_keys(:return)
      end

      my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

      sleep(1)

      # The whole of the configuration survives a reload
      # as it is persisted in the grid

      visit root_path
      my_page.visit!

      filter_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(3)')
      expect(filter_area.area)
        .to have_selector('.id', text: type_work_package.id)

      # as the Subject column is disabled
      expect(filter_area.area)
        .to have_no_selector('.subject', text: type_work_package.subject)

      # As other_type is filtered out
      expect(filter_area.area)
        .to have_no_selector('.id', text: other_type_work_package.id)

      within filter_area.area do
        expect(page).to have_field('editable-toolbar-title', with: 'My WP Filter', wait: 10)
      end
    end
  end

  context 'without the permission to save queries' do
    let(:permissions) { %i[view_work_packages add_work_packages] }

    it 'cannot add the widget' do
      my_page.expect_unable_to_add_widget(1, 1, :within, "Work packages table")
    end
  end
end
