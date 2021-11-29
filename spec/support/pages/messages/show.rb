

require 'support/pages/messages/base'

module Pages::Messages
  class Show < Pages::Messages::Base
    attr_accessor(:message)

    def initialize(message)
      self.message = message
    end

    def expect_subject(subject)
      expect(page).to have_selector('.title-container', text: subject)
    end

    def expect_content(content)
      expect(page).to have_selector('.forum-message .wiki', text: content)
    end

    def expect_no_replies
      expect(page).to have_no_content('Replies')
    end

    def expect_num_replies(num)
      expect(page).to have_content("Replies (#{num})")
    end

    def reply(text)
      find('.ck-content').base.send_keys text

      click_button 'Submit'

      Message.last
    end

    def quote(content:, quoted_message: nil, subject: nil)
      if quoted_message
        within "#message-#{quoted_message.id} .contextual" do
          click_on 'Quote'
        end
      else
        within ".toolbar-items" do
          click_on 'Quote'
        end
      end

      sleep 1

      scroll_to_element find('.ck-content')
      fill_in 'reply_subject', with: subject if subject

      editor = find('.ck-content')
      editor.base.send_keys content

      # For some reason, capybara will click on
      # the button to add another attachment when being told to click on "Submit".
      # Therefor, submitting by enter key.
      subject_field = find('#reply_subject')
      subject_field.native.send_keys(:return)

      Message.last
    end

    def expect_reply(subject:, content:, reply: nil)
      selector = '.comment'
      selector += "#message-#{reply.id}" if reply

      within(selector) do
        expect(page).to have_content(subject)
        expect(page).to have_content(content)
      end
    end

    def expect_current_path(reply = nil)
      replies_to = reply ? "r=#{reply.id}" : nil
      super(replies_to)
    end

    def click_save
      click_button 'Save'
    end

    def path
      topic_path(message)
    end
  end
end
