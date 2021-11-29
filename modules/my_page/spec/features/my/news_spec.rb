

require 'spec_helper'

require_relative '../../support/pages/my/page'

describe 'My page news widget spec', type: :feature, js: true do
  let!(:project) { FactoryBot.create :project }
  let!(:other_project) { FactoryBot.create :project }
  let!(:visible_news) do
    FactoryBot.create :news,
                      project: project,
                      description: 'blubs'
  end
  let!(:invisible_news) do
    FactoryBot.create :news,
                      project: other_project
  end
  let(:other_user) do
    FactoryBot.create(:user)
  end
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: %i[])
  end
  let(:my_page) do
    Pages::My::Page.new
  end

  before do
    login_as user

    my_page.visit!
  end

  it 'can add the widget and see the visible news' do
    # No other widgets exist as the user lacks the permissions for the default widgets
    # add widget in top right corner
    my_page.add_widget(1, 1, :within, 'News')

    news_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')
    news_area.expect_to_span(1, 1, 2, 2)

    expect(page)
      .to have_content visible_news.title
    expect(page)
      .to have_content visible_news.author.name
    expect(page)
      .to have_content visible_news.project.name
    expect(page)
      .to have_content visible_news.created_at.strftime('%m/%d/%Y')

    expect(page)
      .to have_no_content invisible_news.title
  end
end
