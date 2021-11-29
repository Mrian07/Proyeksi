

require 'spec_helper'

describe 'Homescreen index', type: :feature do
  let!(:user) { FactoryBot.build_stubbed(:user) }
  let!(:project) { FactoryBot.create(:public_project, identifier: 'public-project') }

  before do
    login_as user
    visit root_url
  end

  describe 'with a dynamic URL in the welcome text',
           with_settings: {
             welcome_text: "With [a link to the public project]({{opSetting:base_url}}/projects/public-project)",
             welcome_on_homescreen?: true
           } do
    it 'renders the correct link' do
      expect(page)
        .to have_selector("a[href=\"#{OpenProject::Application.root_url}/projects/public-project\"]")

      click_link "a link to the public project"
      expect(page).to have_current_path project_path(project)
    end
  end
end
