

require 'spec_helper'
require_relative '../support/pages/backlogs'

describe 'Backlogs in backlog view',
         type: :feature,
         js: true do
  let!(:project) do
    FactoryBot.create(:project,
                      types: [story, task],
                      enabled_module_names: %w(work_package_tracking backlogs))
  end
  let!(:story) { FactoryBot.create(:type_feature) }
  let!(:other_story) { FactoryBot.create(:type) }
  let!(:task) { FactoryBot.create(:type_task) }
  let!(:priority) { FactoryBot.create(:default_priority) }
  let!(:default_status) { FactoryBot.create(:status, is_default: true) }
  let!(:other_status) { FactoryBot.create(:status) }
  let!(:workflows) do
    FactoryBot.create(:workflow,
                      old_status: default_status,
                      new_status: other_status,
                      role: role,
                      type_id: story.id)
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i(view_master_backlog
                                      add_work_packages
                                      view_work_packages
                                      edit_work_packages
                                      manage_subtasks
                                      manage_versions
                                      update_sprints
                                      assign_versions))
  end
  let!(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let!(:sprint) do
    FactoryBot.create(:version,
                      project: project,
                      start_date: Date.today - 10.days,
                      effective_date: Date.today + 10.days,
                      version_settings_attributes: [{ project: project, display: VersionSetting::DISPLAY_LEFT }])
  end
  let!(:backlog) do
    FactoryBot.create(:version,
                      project: project,
                      version_settings_attributes: [{ project: project, display: VersionSetting::DISPLAY_RIGHT }])
  end
  let!(:other_project) do
    FactoryBot.create(:project)
  end
  let!(:other_project_sprint) do
    FactoryBot.create(:version,
                      project: other_project,
                      sharing: 'system',
                      start_date: Date.today - 10.days,
                      effective_date: Date.today + 10.days)
  end
  let!(:sprint_story1) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: story,
                      status: default_status,
                      version: sprint,
                      position: 1,
                      story_points: 10)
  end
  let(:backlogs_page) { Pages::Backlogs.new(project) }

  before do
    login_as current_user
    allow(Setting)
      .to receive(:plugin_proyeksiapp_backlogs)
            .and_return('story_types' => [story.id.to_s],
                        'task_type' => task.id.to_s)
  end

  it 'displays stories which are editable' do
    backlogs_page.visit!

    backlogs_page
      .expect_sprint(sprint)

    # Shared versions are also displayed as a sprint.
    # Without version settings, it is displayed as a sprint
    backlogs_page
      .expect_sprint(other_project_sprint)

    backlogs_page
      .expect_backlog(backlog)

    # Versions can be folded
    backlogs_page
      .expect_story_in_sprint(sprint_story1, sprint)

    backlogs_page
      .fold_backlog(sprint)

    backlogs_page
      .expect_story_not_in_sprint(sprint_story1, sprint)

    # The backlogs can be folded by default
    visit my_settings_path

    check 'Show versions folded'

    click_button 'Save'

    backlogs_page.visit!

    backlogs_page
      .expect_story_not_in_sprint(sprint_story1, sprint)

    backlogs_page
      .fold_backlog(sprint)

    backlogs_page
      .expect_story_in_sprint(sprint_story1, sprint)

    # Alter the attributes of the sprint
    sleep(0.5)
    backlogs_page
      .edit_backlog(sprint, name: '')

    backlogs_page
      .expect_and_dismiss_error("Name can't be blank.")

    sleep(0.2)

    backlogs_page
      .edit_backlog(sprint,
                    name: 'New sprint name',
                    start_date: Date.today + 5.days,
                    effective_date: Date.today + 20.days)

    sleep(0.5)

    sprint.reload

    expect(sprint.name)
      .to eql 'New sprint name'

    expect(sprint.start_date)
      .to eql Date.today + 5.days

    expect(sprint.effective_date)
      .to eql Date.today + 20.days

    # Alter displaying a sprints as a backlog

    backlogs_page
      .click_in_backlog_menu(sprint, 'Properties')

    select 'right', from: 'Column in backlog'

    click_button 'Save'

    backlogs_page
      .expect_and_dismiss_toaster(message: "Successful update.")

    backlogs_page
      .expect_backlog(sprint)

    # The others are unchanged
    backlogs_page
      .expect_backlog(backlog)

    backlogs_page
      .expect_sprint(other_project_sprint)

    # Alter displaying a backlog as a sprint
    backlogs_page
      .click_in_backlog_menu(backlog, 'Properties')

    select 'left', from: 'Column in backlog'

    click_button 'Save'

    backlogs_page
      .expect_and_dismiss_toaster(message: "Successful update.")

    # Now works as a sprint instead of a backlog
    backlogs_page
      .expect_sprint(backlog)

    # The others are unchanged
    backlogs_page
      .expect_backlog(sprint)

    backlogs_page
      .expect_sprint(other_project_sprint)

    # Alter displaying a version not at all
    backlogs_page
      .click_in_backlog_menu(backlog, 'Properties')

    select 'none', from: 'Column in backlog'

    click_button 'Save'

    backlogs_page
      .expect_and_dismiss_toaster(message: "Successful update.")

    # the disabled backlog/sprint is no longer visible
    expect(page)
      .not_to have_content(backlog.name)

    # The others are unchanged
    backlogs_page
      .expect_backlog(sprint)

    backlogs_page
      .expect_sprint(other_project_sprint)

    # Inherited versions can also be modified
    backlogs_page
      .click_in_backlog_menu(other_project_sprint, 'Properties')

    select 'none', from: 'Column in backlog'

    click_button 'Save'

    backlogs_page
      .expect_and_dismiss_toaster(message: "Successful update.")

    # the disabled backlog/sprint is no longer visible
    expect(page)
      .not_to have_content(other_project_sprint.name)

    # The others are unchanged
    backlogs_page
      .expect_backlog(sprint)

    expect(page)
      .not_to have_content(backlog.name)
  end
end
