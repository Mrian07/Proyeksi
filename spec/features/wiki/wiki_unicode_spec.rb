

require 'spec_helper'

describe 'Wiki unicode title spec', type: :feature, js: true do
  shared_let(:admin) { FactoryBot.create :admin }
  let(:user) { admin }

  let(:project) { FactoryBot.create :project }
  let(:wiki_page_1) do
    FactoryBot.build :wiki_page_with_content,
                     title: '<script>alert("FOO")</script>'
  end
  let(:wiki_page_2) do
    FactoryBot.build :wiki_page_with_content,
                     title: 'Base de données'
  end
  let(:wiki_page_3) do
    FactoryBot.build :wiki_page_with_content,
                     title: 'Base_de_données'
  end

  let(:wiki_body) do
    <<-EOS
    [[Base de données]] should link to wiki_page_2

    [[Base_de_données]] should link to wiki_page_2

    [[base-de-donnees]] should link to wiki_page_2

    [[base-de-donnees-1]] should link to wiki_page_3 (slug duplicate!)

    [[<script>alert("FOO")</script>]]

    EOS
  end

  let(:expected_slugs) do
    %w(base-de-donnees base-de-donnees base-de-donnees base-de-donnees-1 alert-foo)
  end

  let(:expected_titles) do
    [
      'Base de données',
      'Base de données',
      'Base de données',
      'Base_de_données',
      '<script>alert("FOO")</script>'
    ]
  end

  before do
    login_as(user)

    project.wiki.pages << wiki_page_1
    project.wiki.pages << wiki_page_2
    project.wiki.pages << wiki_page_3

    project.wiki.save!

    visit project_wiki_path(project, :wiki)

    # Set value
    find('.ck-content').base.send_keys(wiki_body)
    click_button 'Save'

    expect(page).to have_selector('.title-container h2', text: 'Wiki')
    expect(page).to have_selector('a.wiki-page', count: 5)
  end

  it 'shows renders correct links' do
    expected_titles.each_with_index do |title, i|
      visit project_wiki_path(project, :wiki)

      expect(page).to have_selector('div.wiki-content')
      target_link = all('div.wiki-content a.wiki-page')[i]

      expect(target_link.text).to eq(title)
      expect(target_link[:href]).to match("\/wiki\/#{expected_slugs[i]}")
      target_link.click

      expect(page).to have_selector('.title-container h2', text: title)
    end
  end
end
