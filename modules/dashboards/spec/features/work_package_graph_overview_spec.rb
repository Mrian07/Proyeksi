

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Work package overview graph widget on dashboard',
         type: :feature,
         with_mail: false,
         js: true do
  let!(:type) { FactoryBot.create :type }
  let!(:priority) { FactoryBot.create :default_priority }
  let!(:project) { FactoryBot.create :project, types: [type] }
  let!(:open_status) { FactoryBot.create :default_status }
  let!(:closed_status) { FactoryBot.create :closed_status }
  let!(:open_work_package) do
    FactoryBot.create :work_package,
                      subject: 'Spanning work package',
                      project: project,
                      status: open_status,
                      type: type,
                      author: user,
                      responsible: user
  end
  let!(:closed) do
    FactoryBot.create :work_package,
                      subject: 'Starting work package',
                      project: project,
                      status: closed_status,
                      type: type,
                      author: user,
                      responsible: user
  end

  let(:permissions) do
    %i[view_work_packages
       view_dashboards
       manage_dashboards]
  end

  let(:role) do
    FactoryBot.create(:role, permissions: permissions)
  end

  let(:user) do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:member, project: project, user: u, roles: [role])
    end
  end

  let(:dashboard) do
    Pages::Dashboard.new(project)
  end

  before do
    login_as user

    dashboard.visit!
  end

  # As a graph is rendered as a canvas, we have limited abilities to test the widget
  it 'can add the widget' do
    sleep(0.1)

    dashboard.add_widget(1, 1, :within, "Work packages overview")

    # As the user lacks the necessary permisisons, no widget is preconfigured
    overview_widget = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

    overview_widget.expect_to_span(1, 1, 2, 2)
  end
end
