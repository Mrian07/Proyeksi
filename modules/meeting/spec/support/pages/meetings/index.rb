

require_relative './new'

module Pages::Meetings
  class Index < Pages::Page
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def click_create_new
      within '.toolbar-items' do
        click_link 'Meeting'
      end

      New.new(project)
    end

    def expect_no_create_new_button
      within '.toolbar-items' do
        expect(page)
          .to have_no_link 'Meeting'
      end
    end

    def expect_no_meetings_listed
      within '#content-wrapper' do
        expect(page)
          .to have_content I18n.t(:no_results_title_text)
      end
    end

    def expect_meetings_listed(*meetings)
      within '#content-wrapper' do
        meetings.each do |meeting|
          expect(page).to have_selector(".meeting",
                                        text: meeting.title)
        end
      end
    end

    def expect_meetings_not_listed(*meetings)
      within '#content-wrapper' do
        meetings.each do |meeting|
          expect(page).to have_no_selector(".meeting",
                                           text: meeting.title)
        end
      end
    end

    def expect_to_be_on_page(number)
      expect(page)
        .to have_selector('.op-pagination--item_current',
                          text: number)
    end

    def to_page(number)
      within '.op-pagination--pages' do
        click_link number.to_s
      end
    end

    def to_today
      click_link 'today'
    end

    def navigate_by_menu
      visit project_path(project)
      within '#main-menu' do
        click_link 'Meetings'
      end
    end

    def path
      meetings_path(project)
    end
  end
end
