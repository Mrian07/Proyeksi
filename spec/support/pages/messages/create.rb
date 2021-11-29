

require 'support/pages/messages/base'

module Pages::Messages
  class Create < ::Pages::Messages::Base
    attr_accessor(:forum)

    def initialize(forum)
      self.forum = forum
    end

    def set_subject(subject)
      fill_in 'Subject', with: subject
    end

    def add_text(text)
      find('.ck-content').base.send_keys text
    end

    def click_save
      click_button 'Create'

      Pages::Messages::Show.new(Message.last)
    end

    def created_message
      Message.last
    end

    def path
      new_forum_topic_path(forum)
    end
  end
end
