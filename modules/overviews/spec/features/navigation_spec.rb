

require 'spec_helper'

describe 'Navigate to overview', type: :feature, js: true do
  let(:project) { FactoryBot.create(:project) }
  let(:permissions) { [] }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end

  before do
    login_as user
  end

  it 'can visit the overview page' do
    visit project_path(project)

    within '#menu-sidebar' do
      click_link "Overview"
    end

    within '#content' do
      expect(page)
        .to have_content('Overview')
    end
  end
end
