#-- encoding: UTF-8



require 'spec_helper'

describe 'Work package calendars', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[view_work_packages view_calendar])
  end
  let!(:current_work_package) do
    FactoryBot.create(:work_package,
                      subject: 'Current work package',
                      project: project,
                      start_date: Date.today.at_beginning_of_month + 15.days,
                      due_date: Date.today.at_beginning_of_month + 15.days)
  end
  let!(:another_current_work_package) do
    FactoryBot.create(:work_package,
                      subject: 'Another current work package',
                      project: project,
                      start_date: Date.today.at_beginning_of_month + 12.days,
                      due_date: Date.today.at_beginning_of_month + 18.days)
  end
  let!(:future_work_package) do
    FactoryBot.create(:work_package,
                      subject: 'Future work package',
                      project: project,
                      start_date: Date.today.at_beginning_of_month.next_month + 15.days,
                      due_date: Date.today.at_beginning_of_month.next_month + 15.days)
  end
  let!(:another_future_work_package) do
    FactoryBot.create(:work_package,
                      subject: 'Another future work package',
                      project: project,
                      start_date: Date.today.at_beginning_of_month.next_month + 12.days,
                      due_date: Date.today.at_beginning_of_month.next_month + 18.days)
  end
  let(:filters) { ::Components::WorkPackages::Filters.new }

  before do
    login_as(user)
  end

  it 'navigates to today, allows filtering, switching the view and retrains the state' do
    visit project_path(project)

    within '#main-menu' do
      click_link 'Calendar'
    end

    # should open the calendar with the current month displayed
    expect(page)
      .to have_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_future_work_package.subject

    filters.expect_filter_count 1

    filters.open
    # The filter for the time frame added implicitly should not be visible
    filters.expect_no_filter_by('Dates interval', 'datesInterval')

    # The user can filter by e.g. the subject filter
    filters.add_filter_by 'Subject', 'contains', ['Another']

    # non matching work packages are no longer displayed
    expect(page)
      .to have_no_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_current_work_package.subject

    # The filter for the time frame added implicitly should not be visible
    filters.expect_filter_count 2

    # navigate to the next month
    find('.fc-next-button').click

    expect(page)
      .to have_no_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_future_work_package.subject

    # removing the filter will show the event again
    filters.remove_filter 'subject'

    expect(page)
      .to have_no_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_future_work_package.subject

    future_url = current_url

    # navigate back a month
    find('.fc-prev-button').click

    expect(page)
      .to have_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_future_work_package.subject

    # open the page via the url should show the next month again
    visit future_url

    expect(page)
      .to have_no_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_future_work_package.subject

    # go back a month by using the browser back functionality
    page.execute_script('window.history.back()')

    expect(page)
      .to have_selector '.fc-event-title', text: current_work_package.subject
    expect(page)
      .to have_selector '.fc-event-title', text: another_current_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: future_work_package.subject
    expect(page)
      .to have_no_selector '.fc-event-title', text: another_future_work_package.subject

    # click goes to work package show page
    page.find('.fc-event-title', text: current_work_package.subject).click

    expect(page)
      .to have_selector('.subject-header', text: current_work_package.subject)

    # Going back in browser history will lead us back to the calendar
    # Regression #29664
    page.go_back

    # click goes to work package show page
    expect(page)
      .to have_selector('.fc-event-title', text: current_work_package.subject, wait: 20)

    # click goes to work package show page again
    page.find('.fc-event-title', text: current_work_package.subject).click

    expect(page)
      .to have_selector('.subject-header', text: current_work_package.subject)

    # click back goes back to calendar
    page.find('.work-packages-back-button').click

    expect(page)
      .to have_selector '.fc-event-title', text: current_work_package.subject, wait: 20
  end
end
