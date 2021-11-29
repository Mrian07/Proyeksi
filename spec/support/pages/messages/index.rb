

require 'support/pages/messages/base'

module Pages::Messages
  class Index < ::Pages::Messages::Base
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def path
      project_forums_path(project)
    end

    def click_create_message
      click_on 'Message'

      ::Pages::Messages::Create.new(project.forums.first)
    end

    def expect_listed(subject:, replies: nil, last_message: nil)
      subject = find('table tr td.subject', text: subject)

      row = subject.find(:xpath, '..')

      within(row) do
        expect(page).to have_selector('td.replies', text: replies) if replies
        expect(page).to have_selector('td.last_message', text: last_message) if last_message
      end
    end

    def expect_num_replies(amount)
      expect(page).to have_selector('td.replies', text: amount)
    end
  end
end
