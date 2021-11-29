

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Modifying a dashboard which already has widgets for which permissions are lacking', type: :feature, js: true do
  let!(:project) do
    FactoryBot.create :project
  end

  let(:permissions) do
    %i[view_dashboards
       manage_dashboards]
  end

  let(:user) do
    FactoryBot.create(:user, member_in_project: project, member_with_permissions: permissions)
  end
  let!(:dashboard) do
    FactoryBot.create(:dashboard_with_table, project: project)
  end
  let(:dashboard_page) do
    Pages::Dashboard.new(project)
  end
  let!(:news) do
    FactoryBot.create :news,
                      project: project
  end

  before do
    login_as user

    dashboard_page.visit!
  end

  it 'can add and modify widgets' do
    dashboard_page.add_widget(dashboard.row_count, dashboard.column_count, :row, "News")

    sleep(0.1)

    news_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(2)')

    within news_widget.area do
      expect(page)
        .to have_content(news.title)
    end

    visit root_path

    dashboard_page.visit!

    news_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(2)')

    within news_widget.area do
      expect(page)
        .to have_content(news.title)
    end

    news_widget.remove

    visit root_path

    dashboard_page.visit!

    expect(page)
      .to have_no_selector('.grid--area.-widgeted:nth-of-type(2)')
  end
end
