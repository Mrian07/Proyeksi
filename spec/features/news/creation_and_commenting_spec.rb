#-- encoding: UTF-8



require 'spec_helper'

describe 'News creation and commenting', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project) }
  let!(:other_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[])
  end

  current_user do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[manage_news comment_news])
  end

  it 'allows creating new and commenting it all of which will result in notifications and mails' do
    visit project_news_index_path(project)

    within '.toolbar-items' do
      click_link 'News'
    end

    # Create the news
    fill_in 'Title', with: 'My new news'
    fill_in 'Summary', with: 'The news summary'

    perform_enqueued_jobs do
      click_button 'Create'
    end

    # The new news is visible on the index page
    expect(page)
      .to have_link('My new news')

    expect(page)
      .to have_content 'The news summary'

    # Creating the news will have sent out mails
    expect(ActionMailer::Base.deliveries.size)
      .to be 1

    expect(ActionMailer::Base.deliveries.last.to)
      .to match_array [other_user.mail]

    expect(ActionMailer::Base.deliveries.last.subject)
      .to include 'My new news'

    click_link 'My new news'

    comment_editor = ::Components::WysiwygEditor.new
    comment_editor.set_markdown "A new **text**"

    perform_enqueued_jobs do
      click_button 'Add comment'
    end

    # The new comment is visible on the show page
    expect(page)
      .to have_content "A new text"

    # Creating the news comment will have sent out mails
    expect(ActionMailer::Base.deliveries.size)
      .to be 2

    expect(ActionMailer::Base.deliveries.last.to)
      .to match_array [other_user.mail]

    expect(ActionMailer::Base.deliveries.last.subject)
      .to include 'My new news'
  end
end
