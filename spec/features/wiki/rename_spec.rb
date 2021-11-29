

require 'spec_helper'

describe 'Wiki page', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project, enabled_module_names: %w[wiki]) }
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i[view_wiki_pages
                                                  rename_wiki_pages]
  end
  let!(:wiki_page) do
    FactoryBot.create(:wiki_page_with_content, wiki: project.wiki, title: initial_name)
  end
  let(:initial_name) { 'Initial name' }
  let(:rename_name) { 'Rename name' }

  before do
    login_as(user)
  end

  it 'allows renaming' do
    visit project_wiki_path(project, wiki_page)

    SeleniumHubWaiter.wait
    click_link 'More'
    click_link 'Rename'

    SeleniumHubWaiter.wait
    fill_in 'Title', with: rename_name

    click_button 'Rename'

    expect(page)
      .to have_content(rename_name)

    # One can still use the former name to find the wiki page
    visit project_wiki_path(project, initial_name)

    within('#content') do
      expect(page)
        .to have_content(rename_name)
    end

    # But the application uses the new name preferably
    click_link rename_name

    expect(page)
      .to have_current_path(project_wiki_path(project, 'rename-name'))
  end
end
