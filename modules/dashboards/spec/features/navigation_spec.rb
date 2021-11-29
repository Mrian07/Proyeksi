

require 'spec_helper'

describe 'Navigate to dashboard', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project) }
  let(:permissions) { [:view_dashboards] }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  before do
    login_as user
  end

  it 'can visit the dashboard' do
    visit project_path(project)

    within '#menu-sidebar' do
      click_link "Dashboard"
    end

    within '#content' do
      expect(page)
        .to have_content('Dashboard')
    end
  end
end
