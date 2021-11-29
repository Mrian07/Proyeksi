

require 'spec_helper'

require_relative '../support/pages/overview'

describe 'Overview page managing', type: :feature, js: true, with_mail: false do
  let!(:type) { FactoryBot.create :type }
  let!(:project) { FactoryBot.create :project, types: [type], description: 'My **custom** description' }
  let!(:open_status) { FactoryBot.create :default_status }
  let!(:created_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      author: user
  end
  let!(:assigned_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      assigned_to: user
  end

  let(:permissions) do
    %i[manage_overview
       view_members
       view_work_packages
       add_work_packages
       save_queries
       manage_public_queries]
  end

  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:overview_page) do
    Pages::Overview.new(project)
  end

  before do
    login_as user

    overview_page.visit!
  end

  it 'renders the default view, allows altering and saving' do
    description_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    status_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(2)')
    details_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(3)')
    overview_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(4)')
    members_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(5)')

    description_area.expect_to_exist
    status_area.expect_to_exist
    details_area.expect_to_exist
    overview_area.expect_to_exist
    members_area.expect_to_exist
    description_area.expect_to_span(1, 1, 2, 2)
    status_area.expect_to_span(1, 2, 2, 3)
    details_area.expect_to_span(2, 1, 3, 2)
    overview_area.expect_to_span(3, 1, 4, 3)
    members_area.expect_to_span(2, 2, 3, 3)

    # The widgets load their respective contents
    within description_area.area do
      expect(page)
        .to have_content('My custom description')
    end

    # within top-left area, add an additional widget
    overview_page.add_widget(1, 1, :row, 'Work packages table')

    # Actually there are two success messages displayed currently. One for the grid getting updated and one
    # for the query assigned to the new widget being created. A user will not notice it but the automated
    # browser can get confused. Therefore we wait.
    sleep(1)

    overview_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    table_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(6)')
    table_area.expect_to_span(1, 1, 2, 2)

    # A useless resizing shows no message and does not alter the size
    table_area.resize_to(1, 1)

    overview_page.expect_no_toaster message: I18n.t('js.notice_successful_update')

    table_area.expect_to_span(1, 1, 2, 2)

    table_area.resize_to(1, 2)

    overview_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    # Resizing leads to the table area now spanning a larger area
    table_area.expect_to_span(1, 1, 2, 3)

    within table_area.area do
      expect(page)
        .to have_content(created_work_package.subject)
      expect(page)
        .to have_content(assigned_work_package.subject)
    end

    sleep(0.1)

    # Reloading kept the user's values
    visit home_path
    overview_page.visit!

    ## Because of the added column and the resizing the other widgets have moved down
    description_area.expect_to_span(2, 1, 3, 2)
    status_area.expect_to_span(2, 2, 4, 3)
    details_area.expect_to_span(3, 1, 4, 2)
    overview_area.expect_to_span(5, 1, 6, 3)
    members_area.expect_to_span(4, 2, 5, 3)
    table_area.expect_to_span(1, 1, 2, 3)
  end
end
