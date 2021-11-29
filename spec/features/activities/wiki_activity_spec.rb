

require 'spec_helper'

feature 'Wiki activities' do
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %w[view_wiki_pages
                                                  edit_wiki_pages
                                                  view_wiki_edits]
  end
  let(:project) { FactoryBot.create :project, enabled_module_names: %w[wiki activity] }
  let(:wiki) { project.wiki }
  let(:editor) { Components::WysiwygEditor.new }

  before do
    login_as user
  end

  it 'tracks the wiki\'s activities', js: true do
    # create a wiki page
    visit project_wiki_path(project, 'mypage')

    fill_in 'content_page_title', with: 'My page'

    editor.set_markdown('First content')

    click_button 'Save'
    expect(page).to have_text("Successful creation")

    # We mock letting some time pass by altering the timestamps
    Journal.last.update_columns(created_at: Time.now - 5.days, updated_at: Time.now - 5.days)

    # alter the page
    SeleniumHubWaiter.wait
    click_link 'Edit'

    editor.set_markdown('Second content')

    click_button 'Save'
    expect(page).to have_text("Successful update")

    # After creating and altering the page, there
    # will be two activities to see
    visit project_activity_index_path(project)

    check 'Wiki edits'

    click_button 'Apply'

    expect(page)
      .to have_link('Wiki edit: My page (#1)')

    expect(page)
      .to have_link('Wiki edit: My page (#2)')

    click_link('Wiki edit: My page (#2)')

    expect(page)
      .to have_current_path(project_wiki_path(project.id, 'my-page', version: 2))

    # disable the wiki module

    project.enabled_module_names = %w[activity]
    project.save!

    # Go to activity page again to see that
    # there is no more option to see wiki edits.

    visit project_activity_index_path(project)

    expect(page)
      .to have_no_content('Wiki edits')
  end
end
