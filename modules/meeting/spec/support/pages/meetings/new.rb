

require_relative './base'
require_relative './show'

module Pages::Meetings
  class New < Base
    def click_create
      click_button 'Create'

      meeting = Meeting.last

      if meeting
        Pages::Meetings::Show.new(meeting)
      else
        self
      end
    end

    def set_title(text)
      fill_in 'Title', with: text
    end

    def set_start_date(date)
      fill_in 'Start date', with: date
    end

    def set_start_time(time)
      fill_in 'Time', with: time
    end

    def set_duration(duration)
      fill_in 'Duration', with: duration
    end

    def invite(user)
      check "#{user.name} invited"
    end

    def path
      new_meeting_path(project)
    end
  end
end
