

require_relative './base'
require_relative './show'

module Pages::Meetings
  class Edit < Base
    attr_accessor :meeting

    def initialize(meeting)
      self.meeting = meeting
    end

    def expect_available_participant(user)
      expect(page)
        .to have_field("#{user} invited")
    end

    def expect_not_available_participant(user)
      expect(page)
        .to have_no_field("#{user} invited")
    end

    def invite(user)
      check("#{user} invited")
    end

    def uninvite(user)
      uncheck("#{user} invited")
    end

    def click_save
      click_button('Save')

      Pages::Meetings::Show.new(meeting)
    end

    def path
      edit_meeting_path(meeting)
    end
  end
end
