

require 'spec_helper'
require_relative '../support/pages/work_package_github_tab'

describe 'Open the GitHub tab', type: :feature, js: true do
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i(view_work_packages
                                      add_work_package_notes
                                      show_github_content))
  end
  let(:project) { FactoryBot.create :project }
  let(:work_package) { FactoryBot.create(:work_package, project: project, subject: 'A test work_package') }
  let(:github_tab) { Pages::GitHubTab.new(work_package.id) }
  let(:pull_request) { FactoryBot.create :github_pull_request, :open, work_packages: [work_package], title: 'A Test PR title' }
  let(:check_run) { FactoryBot.create :github_check_run, github_pull_request: pull_request, name: 'a check run name' }

  shared_examples_for "a github tab" do
    before do
      check_run
      login_as(user)
    end

    # compares the clipboard content by drafting a new comment, pressing ctrl+v and
    # comparing the pasted content against the provided text
    def expect_clipboard_content(text)
      work_package_page.switch_to_tab(tab: 'activity')

      work_package_page.trigger_edit_comment
      work_package_page.update_comment(' ') # ensure the comment editor is fully loaded
      github_tab.paste_clipboard_content
      expect(work_package_page.add_comment_container).to have_content(text)

      work_package_page.switch_to_tab(tab: 'github')
    end

    it 'shows the github tab when the user is allowed to see it' do
      work_package_page.visit!
      work_package_page.switch_to_tab(tab: 'github')

      github_tab.git_actions_menu_button.click
      github_tab.git_actions_copy_branch_name_button.click
      expect(page).to have_text('Copied!')
      expect_clipboard_content("#{work_package.type.name.downcase}/#{work_package.id}-a-test-work_package")

      expect(page).to have_text('A Test PR title')
      expect(page).to have_text('a check run name')
    end

    context 'when there are no pull requests' do
      let(:check_run) {}
      let(:pull_request) {}

      it 'shows the github tab with an empty-pull-requests message' do
        work_package_page.visit!
        work_package_page.switch_to_tab(tab: 'github')
        expect(page).to have_content('There are no pull requests')
        expect(page).to have_content("Link an existing PR by using the code OP##{work_package.id}")
      end
    end

    context 'when the user does not have the permissions to see the github tab' do
      let(:role) do
        FactoryBot.create(:role,
                          permissions: %i(view_work_packages
                                          add_work_package_notes))
      end

      it 'does not show the github tab' do
        work_package_page.visit!

        github_tab.expect_tab_not_present
      end
    end

    context 'when the github integration is not enabled for the project' do
      let(:project) { FactoryBot.create(:project, disable_modules: 'github') }

      it 'does not show the github tab' do
        work_package_page.visit!

        github_tab.expect_tab_not_present
      end
    end
  end

  describe 'work package full view' do
    let(:work_package_page) { Pages::FullWorkPackage.new(work_package) }

    it_behaves_like 'a github tab'
  end

  describe 'work package split view' do
    let(:work_package_page) { Pages::SplitWorkPackage.new(work_package) }

    it_behaves_like 'a github tab'
  end
end
