

require 'spec_helper'

describe 'sticky messages', type: :feature do
  let(:forum) { FactoryBot.create(:forum) }

  let!(:message1) do
    FactoryBot.create :message, forum: forum, created_at: Time.now - 1.minute do |message|
      Message.where(id: message.id).update_all(updated_at: Time.now - 1.minute)
    end
  end
  let!(:message2) do
    FactoryBot.create :message, forum: forum, created_at: Time.now - 2.minute do |message|
      Message.where(id: message.id).update_all(updated_at: Time.now - 2.minute)
    end
  end
  let!(:message3) do
    FactoryBot.create :message, forum: forum, created_at: Time.now - 3.minute do |message|
      Message.where(id: message.id).update_all(updated_at: Time.now - 3.minute)
    end
  end

  let(:user) do
    FactoryBot.create :user,
                      member_in_project: forum.project,
                      member_through_role: role
  end
  let(:role) { FactoryBot.create(:role, permissions: [:edit_messages]) }

  before do
    login_as user
    visit project_forum_path(forum.project, forum)
  end

  def expect_order_of_messages(*order)
    order.each_with_index do |message, index|
      expect(page).to have_selector("table tbody tr:nth-of-type(#{index + 1})", text: message.subject)
    end
  end

  scenario 'sticky messages are on top' do
    expect_order_of_messages(message1, message2, message3)

    click_link(message2.subject)

    click_link('Edit')

    check('message[sticky]')
    click_button('Save')

    visit project_forum_path(forum.project, forum)

    expect_order_of_messages(message2, message1, message3)
  end
end
