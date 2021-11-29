

require 'spec_helper'

describe 'onboarding tour for new users', js: true do
  let(:user) { FactoryBot.create :admin }
  let(:project) do
    FactoryBot.create :project, name: 'Demo project', identifier: 'demo-project', public: true,
                                enabled_module_names: %w[work_package_tracking wiki]
  end
  let(:project_link) { "<a href=/projects/#{project.identifier}> #{project.name} </a>" }

  let(:scrum_project) do
    FactoryBot.create :project, name: 'Scrum project', identifier: 'your-scrum-project', public: true,
                                enabled_module_names: %w[work_package_tracking]
  end
  let(:scrum_project_link) { "<a href=/projects/#{scrum_project.identifier}> #{scrum_project.name} </a>" }

  let!(:wp1) { FactoryBot.create(:work_package, project: project) }
  let(:next_button) { find('.enjoyhint_next_btn') }

  context 'with a new user' do
    before do
      login_as user
      allow(Setting).to receive(:demo_projects_available).and_return(true)
      allow(Setting).to receive(:welcome_title).and_return('Hey ho!')
      allow(Setting).to receive(:welcome_on_homescreen?).and_return(true)
    end

    it 'I can select a language' do
      visit home_path first_time_user: true
      expect(page).to have_text 'Please select your language'

      select 'Deutsch', from: 'user_language'
      click_button 'Save'

      expect(page).to have_text 'Projekt auswählen'
    end

    context 'the tutorial does not start' do
      before do
        allow(Setting).to receive(:welcome_text).and_return("<a> #{project.name} </a>")
        visit home_path first_time_user: true

        # SeleniumHubWaiter.wait
        select 'English', from: 'user_language'
        click_button 'Save'
      end

      it 'when the welcome block does not include the demo projects' do
        expect(page).to have_no_text sanitize_string(I18n.t('js.onboarding.steps.welcome')), normalize_ws: true
        expect(page).to have_no_selector '.enjoyhint_next_btn'
      end
    end

    context 'when I skip the language selection' do
      before do
        allow(Setting)
          .to receive(:welcome_text)
          .and_return(project_link + scrum_project_link)
        visit home_path first_time_user: true
      end

      after do
        # Clear session to avoid that the onboarding tour starts
        page.execute_script("window.sessionStorage.clear();")
      end

      it 'the tutorial starts directly' do
        visit home_path first_time_user: true
        expect(page).to have_text 'Please select your language'

        # Cancel language selection
        click_button('Close popup')

        # The tutorial appears
        expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.welcome')), normalize_ws: true
        expect(page).to have_selector '.enjoyhint_next_btn:not(.enjoyhint_hide)'
      end
    end

    context 'the tutorial starts' do
      before do
        allow(Setting)
          .to receive(:welcome_text)
          .and_return(project_link + scrum_project_link)
        visit home_path first_time_user: true

        select 'English', from: 'user_language'
        click_button 'Save'
        SeleniumHubWaiter.wait
      end

      after do
        # Clear session to avoid that the onboarding tour starts
        page.execute_script("window.sessionStorage.clear();")
      end

      it 'directly after the language selection' do
        # The tutorial appears
        expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.welcome')), normalize_ws: true
        expect(page).to have_selector '.enjoyhint_next_btn:not(.enjoyhint_hide)'
      end

      it 'and I skip the tutorial' do
        find('.enjoyhint_skip_btn').click

        # The tutorial disappears
        expect(page).to have_no_text sanitize_string(I18n.t('js.onboarding.steps.welcome')), normalize_ws: true
        expect(page).to have_no_selector '.enjoyhint_next_btn'

        page.driver.browser.navigate.refresh

        # The tutorial did not start again
        expect(page).to have_no_text sanitize_string(I18n.t('js.onboarding.steps.welcome')), normalize_ws: true
        expect(page).to have_no_selector '.enjoyhint_next_btn'
      end

      it 'and I continue the tutorial' do
        next_button.click
        expect(page).to have_text sanitize_string(I18n.t('js.onboarding.steps.project_selection')), normalize_ws: true

        # SeleniumHubWaiter.wait
        find('.welcome').click_link 'Demo project'
        expect(page).to have_current_path "/projects/#{project.identifier}/work_packages?start_onboarding_tour=true"

        step_through_onboarding_wp_tour project, wp1

        step_through_onboarding_main_menu_tour has_full_capabilities: true
      end
    end
  end

  context 'with a new user who is not allowed to see the parts of the tour' do
    # necessary to be able to see public projects
    let(:non_member_role) { FactoryBot.create :non_member, permissions: [:view_work_packages] }
    let(:non_member_user) { FactoryBot.create :user }

    before do
      allow(Setting).to receive(:demo_projects_available).and_return(true)
      non_member_role
      login_as non_member_user
    end

    it 'skips these steps and continues directly' do
      # Set the tour parameter so that we can start on the overview page
      visit "/projects/#{project.identifier}/work_packages?start_onboarding_tour=true"
      step_through_onboarding_wp_tour project, wp1

      step_through_onboarding_main_menu_tour has_full_capabilities: false
    end
  end
end
