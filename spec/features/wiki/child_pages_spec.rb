

require 'spec_helper'

describe 'wiki child pages', type: :feature, js: true do
  let(:project) do
    FactoryBot.create(:project)
  end
  let(:user) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_through_role: role
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_wiki_pages edit_wiki_pages])
  end
  let(:parent_page) do
    FactoryBot.create(:wiki_page_with_content,
                      wiki: project.wiki)
  end
  let(:child_page_name) { 'The child page !@#{$%^&*()_},./<>?;\':' }

  before do
    login_as user
  end

  scenario 'adding a childpage' do
    visit project_wiki_path(project, parent_page.title)

    click_on 'Wiki page'

    SeleniumHubWaiter.wait
    fill_in 'content_page_title', with: child_page_name

    find('.ck-content').set('The child page\'s content')

    click_button 'Save'

    # hierarchy displayed in the breadcrumb
    expect(page).to have_selector('#breadcrumb [data-qa-selector="op-breadcrumb"]',
                                  text: parent_page.title.to_s)

    # hierarchy displayed in the sidebar
    expect(page).to have_selector('.pages-hierarchy',
                                  text: "#{parent_page.title}\n#{child_page_name}")

    # on toc page
    visit index_project_wiki_index_path(project)

    expect(page).to have_content(child_page_name)
  end
end
