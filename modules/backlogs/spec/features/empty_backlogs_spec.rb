

require 'spec_helper'

describe 'Empty backlogs project',
         type: :feature,
         js: true do
  let(:project) { FactoryBot.create(:project, types: [story, task], enabled_module_names: %w(backlogs)) }
  let(:story) { FactoryBot.create(:type_feature) }
  let(:task) { FactoryBot.create(:type_task) }
  let(:status) { FactoryBot.create(:status, is_default: true) }

  before do
    project
    status

    login_as current_user
    allow(Setting)
        .to receive(:plugin_openproject_backlogs)
                .and_return('story_types' => [story.id.to_s],
                            'task_type' => task.id.to_s)

    visit backlogs_project_backlogs_path(project)
  end

  context 'as admin' do
    let(:current_user) { FactoryBot.create(:admin) }

    it 'should show a no results box with action' do
      expect(page).to have_selector '.generic-table--no-results-container', text: I18n.t(:backlogs_empty_title)
      expect(page).to have_selector '.generic-table--no-results-description', text: I18n.t(:backlogs_empty_action_text)

      link = page.find '.generic-table--no-results-description a'
      expect(link[:href]).to include(new_project_version_path(project))
    end
  end

  context 'as regular member' do
    let(:role) { FactoryBot.create(:role, permissions: %i(view_master_backlog)) }
    let(:current_user) { FactoryBot.create :user, member_in_project: project, member_through_role: role }

    it 'should only show a no results box' do
      expect(page).to have_selector '.generic-table--no-results-container', text: I18n.t(:backlogs_empty_title)
      expect(page).to have_no_selector '.generic-table--no-results-description'
    end
  end
end
