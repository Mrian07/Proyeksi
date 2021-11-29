

require 'spec_helper'

require_relative '../../support/pages/my/page'

describe 'Accountable widget on my page', type: :feature, js: true do
  let!(:type) { FactoryBot.create :type }
  let!(:priority) { FactoryBot.create :default_priority }
  let!(:project) { FactoryBot.create :project, types: [type] }
  let!(:other_project) { FactoryBot.create :project, types: [type] }
  let!(:open_status) { FactoryBot.create :default_status }
  let!(:accountable_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      author: user,
                      responsible: user
  end
  let!(:accountable_by_other_work_package) do
    FactoryBot.create :work_package,
                      project: project,
                      type: type,
                      author: user,
                      responsible: other_user
  end
  let!(:accountable_but_invisible_work_package) do
    FactoryBot.create :work_package,
                      project: other_project,
                      type: type,
                      author: user,
                      responsible: user
  end
  let(:other_user) do
    FactoryBot.create(:user)
  end

  let(:role) { FactoryBot.create(:role, permissions: %i[view_work_packages add_work_packages save_queries]) }

  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:my_page) do
    Pages::My::Page.new
  end

  before do
    login_as user

    my_page.visit!
  end

  it 'can add the widget and see the work packages the user is accountable for' do
    # Add widget below existing widgets
    my_page.add_widget(2, 2, :row, "Work packages I am accountable for")

    # Actually there are two success messages displayed currently. One for the grid getting updated and one
    # for the query assigned to the new widget being created. A user will not notice it but the automated
    # browser can get confused. Therefore we wait.
    sleep(1)

    my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    accountable_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(3)')

    accountable_area.expect_to_span(2, 2, 3, 3)

    assigned_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    assigned_area.remove

    my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    created_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    created_area.expect_to_span(1, 1, 2, 2)
    # as the assigned widget was removed, the numbers have changed
    accountable_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(2)')
    accountable_area.expect_to_span(2, 1, 3, 2)

    expect(accountable_area.area)
      .to have_selector('.subject', text: accountable_work_package.subject)

    expect(accountable_area.area)
      .to have_no_selector('.subject', text: accountable_by_other_work_package.subject)

    expect(accountable_area.area)
      .to have_no_selector('.subject', text: accountable_but_invisible_work_package.subject)
  end
end
