

require 'spec_helper'

describe 'Wiki page navigation spec', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  current_user { admin }

  let(:project) { FactoryBot.create :project, enabled_module_names: %w[wiki] }
  let!(:wiki_page_55) do
    FactoryBot.create :wiki_page_with_content,
                      wiki: project.wiki,
                      title: 'Wiki Page No. 55'
  end
  let!(:wiki_pages) do
    FactoryBot.create_list(:wiki_page_with_content, 30, wiki: project.wiki)
  end

  # Always use the same user for the wiki pages
  # that otherwise gets created
  before do
    FactoryBot.set_factory_default(:author, admin)
  end

  it 'scrolls to the selected page on load (Regression #36937)' do
    visit project_wiki_path(project, wiki_page_55)

    expect(page).to have_selector('div.wiki-content')

    expect(page).to have_selector('.title-container h2', text: 'Wiki Page No. 55')

    # Expect scrolled to menu node
    expect_element_in_view page.find('.tree-menu--item.-selected', text: 'Wiki Page No. 55')
  end
end
