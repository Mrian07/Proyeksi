

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Subprojects widget on dashboard', type: :feature, js: true do
  let!(:project) do
    FactoryBot.create(:project, parent: parent_project)
  end

  let!(:child_project) do
    FactoryBot.create(:project, parent: project)
  end
  let!(:invisible_child_project) do
    FactoryBot.create(:project, parent: project)
  end
  let!(:grandchild_project) do
    FactoryBot.create(:project, parent: child_project)
  end
  let!(:parent_project) do
    FactoryBot.create(:project)
  end

  let(:permissions) do
    %i[view_dashboards
       manage_dashboards]
  end

  let(:role) do
    FactoryBot.create(:role, permissions: permissions)
  end

  let(:user) do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:member, project: project, roles: [role], user: u)
      FactoryBot.create(:member, project: child_project, roles: [role], user: u)
      FactoryBot.create(:member, project: grandchild_project, roles: [role], user: u)
      FactoryBot.create(:member, project: parent_project, roles: [role], user: u)
    end
  end
  let(:dashboard_page) do
    Pages::Dashboard.new(project)
  end

  before do
    login_as user

    dashboard_page.visit!
  end

  it 'can add the widget and see the description in it' do
    dashboard_page.add_widget(1, 1, :within, "Subprojects")

    sleep(0.1)

    subprojects_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

    expect(page)
      .to have_link(child_project.name, wait: 10)

    within(subprojects_widget.area) do
      expect(page)
        .to have_link(child_project.name)
      expect(page)
        .not_to have_link(grandchild_project.name)
      expect(page)
        .not_to have_link(invisible_child_project.name)
      expect(page)
        .not_to have_link(parent_project.name)
      expect(page)
        .not_to have_link(project.name)
    end
  end
end
