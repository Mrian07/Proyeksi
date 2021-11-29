

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Dashboard page members', type: :feature, js: true, with_mail: false do
  shared_let(:type) { FactoryBot.create :type }
  shared_let(:project) { FactoryBot.create :project, types: [type], description: 'My **custom** description' }

  shared_let(:permissions) do
    %i[manage_dashboards
       view_dashboards
       view_members
      ]
  end

  shared_let(:user) do
    FactoryBot.create(:user,
                      firstname: 'Foo',
                      lastname: 'Bar',
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  shared_let(:group) do
    FactoryBot.create(:group,
                      name: 'DEV Team',
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  shared_let(:placeholder) do
    FactoryBot.create(:placeholder_user,
                      name: 'DEVELOPER PLACEHOLDER',
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  let(:dashboard_page) do
    Pages::Dashboard.new(project)
  end

  before do
    login_as user

    dashboard_page.visit!
  end

  it 'renders the default view, allows altering and saving' do
    # within top-right area, add an additional widget
    dashboard_page.add_widget(1, 1, :within, 'Members')

    members_block = page.find('.widget-box', text: 'MEMBERS')

    within(members_block) do
      user_link = find('op-principal a', text: user.name)
      expect(user_link['href']).to end_with user_path(user.id)

      group_link = find('op-principal a', text: group.name)
      expect(group_link['href']).to end_with show_group_path(group.id)

      placeholder_link = find('op-principal a', text: placeholder.name)
      expect(placeholder_link['href']).to end_with placeholder_user_path(placeholder.id)
    end
  end
end
