

require_relative './base'

module Pages::Meetings
  class Show < Base
    attr_accessor :meeting

    def initialize(meeting)
      self.meeting = meeting
    end

    def expect_no_invited
      expect(page)
        .to have_content("#{Meeting.human_attribute_name(:participants_invited)}: -")
    end

    def expect_no_attended
      expect(page)
        .to have_content("#{Meeting.human_attribute_name(:participants_attended)}: -")
    end

    def expect_invited(*users)
      users.each do |user|
        within(".meeting.details") do
          expect(page)
            .to have_link(user.name)
        end
      end
    end

    def expect_uninvited(*users)
      users.each do |user|
        within(".meeting.details") do
          expect(page)
            .to have_no_link(user.name)
        end
      end
    end

    def expect_date_time(expected)
      expect(page)
        .to have_content("Time: #{expected}")
    end

    def click_edit
      within '.meeting--main-toolbar .toolbar-items' do
        click_link 'Edit'
      end
    end

    def path
      meeting_path(meeting)
    end
  end
end
