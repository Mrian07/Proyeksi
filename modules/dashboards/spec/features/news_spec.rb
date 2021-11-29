

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'News widget on dashboard', type: :feature, js: true do
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
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[view_news
                                      view_dashboards
                                      manage_dashboards])
  end
  let(:user) do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:member, project: project, roles: [role], user: u)
      FactoryBot.create(:member, project: other_project, roles: [role], user: u)
    end
  end

  let(:dashboard) do
    Pages::Dashboard.new(project)
  end

  before do
    login_as user

    dashboard.visit!
  end

  it 'can add the widget and see the visible news' do
    # within top-right area, add an additional widget
    dashboard.add_widget(1, 1, :within, 'News')

    news_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

    within news_widget.area do
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
end
