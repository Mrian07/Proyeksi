

require 'spec_helper'

require_relative '../../support/pages/my/page'

describe 'My page', type: :feature, js: true do
  let!(:type) { FactoryBot.create :type }
  let!(:project) { FactoryBot.create :project, types: [type] }
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

  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[view_work_packages add_work_packages save_queries])
  end
  let(:my_page) do
    Pages::My::Page.new
  end

  before do
    login_as user

    my_page.visit!
  end

  def grid
    @grid ||= Grids::MyPage.first
  end

  def reload_grid!
    @grid = Grids::MyPage.first
  end

  def assigned_area
    find_area("Work packages assigned to me")
  end

  def created_area
    find_area("Work packages created by me")
  end

  def calendar_area
    find_area("Calendar")
  end

  def news_area
    find_area("News")
  end

  def watched_area
    find_area("Work packages watched by me")
  end

  def find_area(name)
    index = grid.widgets.sort_by(&:id).each_with_index.detect { |w, _index| w.options["name"] == name }.last

    Components::Grids::GridArea.new(".grid--area.-widgeted:nth-of-type(#{index + 1})")
  end

  it 'renders the default view, allows altering and saving' do
    sleep(0.5)

    assigned_area.expect_to_exist
    created_area.expect_to_exist
    assigned_area.expect_to_span(1, 1, 2, 2)
    created_area.expect_to_span(1, 2, 2, 3)

    # The widgets load their respective contents
    expect(page)
      .to have_content(created_work_package.subject)
    expect(page)
      .to have_content(assigned_work_package.subject)

    # add widget above to right area
    my_page.add_widget(1, 1, :row, 'Calendar')

    sleep(0.5)
    reload_grid!

    calendar_area.expect_to_span(1, 1, 2, 2)

    # resizing will move the created area down
    calendar_area.resize_to(1, 2)

    sleep(0.1)

    # resizing again will not influence the created area. It will stay down
    calendar_area.resize_to(1, 1)

    calendar_area.expect_to_span(1, 1, 2, 2)

    # add widget right next to the calendar widget
    my_page.add_widget(1, 2, :within, 'News')

    sleep(0.5)
    reload_grid!

    news_area.expect_to_span(1, 2, 2, 3)

    calendar_area.resize_to(2, 1)

    sleep(0.3)

    # Resizing leads to the calendar area now spanning a larger area
    calendar_area.expect_to_span(1, 1, 3, 2)
    # Because of the added row, and the resizing the other widgets (assigned and created) have moved down
    assigned_area.expect_to_span(3, 1, 4, 2)
    created_area.expect_to_span(2, 2, 3, 3)

    my_page.add_widget(1, 3, :column, 'Work packages watched by me')

    sleep(0.5)
    reload_grid!

    watched_area.expect_to_exist

    sleep(1)

    # dragging makes room for the dragged widget which means
    # that widgets that have been there are moved down
    created_area.drag_to(1, 3)

    my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    reload_grid!

    calendar_area.expect_to_span(1, 1, 3, 2)
    watched_area.expect_to_span(2, 3, 3, 4)
    assigned_area.expect_to_span(3, 1, 4, 2)
    created_area.expect_to_span(1, 3, 2, 4)
    news_area.expect_to_span(1, 2, 2, 3)

    # dragging again makes room for the dragged widget which means
    # that widgets that have been there are moved down. Additionally,
    # as no more widgets start in the second column, that column is removed
    news_area.drag_to(1, 3)

    my_page.expect_and_dismiss_toaster message: I18n.t('js.notice_successful_update')

    reload_grid!

    # Reloading keeps the user's values
    visit home_path
    my_page.visit!

    calendar_area.expect_to_span(1, 1, 3, 2)
    news_area.expect_to_span(1, 2, 2, 3)
    created_area.expect_to_span(2, 2, 3, 3)
    assigned_area.expect_to_span(3, 1, 4, 2)
    watched_area.expect_to_span(3, 2, 4, 3)
  end
end
