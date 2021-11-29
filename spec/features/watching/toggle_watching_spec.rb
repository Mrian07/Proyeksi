

require 'spec_helper'

describe 'Toggle watching', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role, permissions: %i[view_messages view_wiki_pages]) }
  let(:user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }
  let(:news) { FactoryBot.create(:news, project: project) }
  let(:forum) { FactoryBot.create(:forum, project: project) }
  let(:message) { FactoryBot.create(:message, forum: forum) }
  let(:wiki) { project.wiki }
  let(:wiki_page) { FactoryBot.create(:wiki_page_with_content, wiki: wiki) }

  before do
    allow(User).to receive(:current).and_return user
  end

  it 'can toggle watch and unwatch' do
    # Work packages have a different toggle and are hence not considered here
    [news_path(news),
     project_forum_path(project, forum),
     topic_path(message),
     project_wiki_path(project, wiki_page)].each do |path|
       visit path
       click_link(I18n.t('button_watch'))
       expect(page).to have_link(I18n.t('button_unwatch'))

       SeleniumHubWaiter.wait
       click_link(I18n.t('button_unwatch'))
       expect(page).to have_link(I18n.t('button_watch'))
     end
  end
end
