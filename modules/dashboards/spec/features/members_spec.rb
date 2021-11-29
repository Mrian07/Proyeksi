

require 'spec_helper'

require_relative '../support/pages/dashboard'

describe 'Members widget on dashboard', type: :feature, js: true do
  let!(:project) { FactoryBot.create :project }
  let!(:other_project) { FactoryBot.create :project }

  let!(:manager_user) do
    FactoryBot.create :user, lastname: "Manager", member_in_project: project, member_through_role: role
  end
  let!(:no_edit_member_user) do
    FactoryBot.create :user, lastname: "No_Edit", member_in_project: project, member_through_role: no_edit_member_role
  end
  let!(:no_view_member_user) do
    FactoryBot.create :user, lastname: "No_View", member_in_project: project, member_through_role: no_view_member_role
  end
  let!(:placeholder_user) do
    FactoryBot.create :placeholder_user,
                      lastname: "Placeholder user",
                      member_in_project: project,
                      member_through_role: no_view_member_role
  end
  let!(:invisible_user) do
    FactoryBot.create :user, lastname: "Invisible", member_in_project: other_project, member_through_role: role
  end

  let(:no_view_member_role) do
    FactoryBot.create(:role,
                      permissions: %i[manage_dashboards
                                      view_dashboards])
  end
  let(:no_edit_member_role) do
    FactoryBot.create(:role,
                      permissions: %i[manage_dashboards
                                      view_dashboards
                                      view_members])
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[manage_dashboards
                                      view_dashboards
                                      manage_members
                                      view_members])
  end
  let(:dashboard) do
    Pages::Dashboard.new(project)
  end

  before do
    login_as manager_user

    dashboard.visit!
  end

  def expect_all_members_visible(area)
    within area do
      expect(page)
        .to have_content role.name
      expect(page)
        .to have_content manager_user.name
      expect(page)
        .to have_content no_edit_member_role
      expect(page)
        .to have_content no_edit_member_user.name
      expect(page)
        .to have_content no_view_member_role
      expect(page)
        .to have_content no_view_member_user.name
      expect(page)
        .to have_content placeholder_user.name
    end
  end

  it 'can add the widget and see the members if the permissions suffice' do
    # within top-right area, add an additional widget
    dashboard.add_widget(1, 1, :within, 'Members')

    members_area = Components::Grids::GridArea.new('.grid--area.-widgeted:nth-of-type(1)')

    expect_all_members_visible(members_area.area)

    expect(page)
      .not_to have_content invisible_user.name

    within members_area.area do
      expect(page)
        .to have_link('Member')
    end

    # A user without edit permission will see the members but cannot add one
    login_as no_edit_member_user

    visit root_path
    dashboard.visit!

    expect_all_members_visible(members_area.area)

    within members_area.area do
      expect(page)
        .to have_no_link('Member')
    end

    # A user without view permission will not see any members
    login_as no_view_member_user

    visit root_path

    dashboard.visit!

    within members_area.area do
      expect(page)
        .to have_no_content manager_user.name

      expect(page)
        .to have_content('No visible members')

      expect(page)
        .to have_no_link('Member')

      expect(page)
        .to have_no_link('View all members')
    end
  end
end
