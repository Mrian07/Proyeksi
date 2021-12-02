

require 'spec_helper'

describe 'Impediments on taskboard',
         type: :feature,
         js: true do
  let!(:project) do
    FactoryBot.create(:project,
                      types: [story, task],
                      enabled_module_names: %w(work_package_tracking backlogs))
  end
  let!(:story) { FactoryBot.create(:type_feature) }
  let!(:task) { FactoryBot.create(:type_task) }
  let!(:priority) { FactoryBot.create(:default_priority) }
  let!(:status) { FactoryBot.create(:status, is_default: true) }
  let!(:other_status) { FactoryBot.create(:status) }
  let!(:workflows) do
    FactoryBot.create(:workflow,
                      old_status: status,
                      new_status: other_status,
                      role: role,
                      type_id: story.id)
    FactoryBot.create(:workflow,
                      old_status: status,
                      new_status: other_status,
                      role: role,
                      type_id: task.id)
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i(view_taskboards
                                      add_work_packages
                                      view_work_packages
                                      edit_work_packages
                                      manage_subtasks
                                      assign_versions))
  end
  let!(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let!(:task1) do
    FactoryBot.create(:work_package,
                      status: status,
                      project: project,
                      type: task,
                      version: sprint,
                      parent: story1)
  end
  let!(:story1) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: story,
                      version: sprint)
  end
  let!(:other_task) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: task,
                      version: sprint,
                      parent: other_story)
  end
  let!(:other_story) do
    FactoryBot.create(:work_package,
                      project: project,
                      type: story,
                      version: other_sprint)
  end
  let!(:sprint) do
    FactoryBot.create(:version, project: project)
  end
  let!(:other_sprint) do
    FactoryBot.create(:version, project: project)
  end

  before do
    login_as current_user
    allow(Setting)
      .to receive(:plugin_proyeksiapp_backlogs)
      .and_return('story_types' => [story.id.to_s],
                  'task_type' => task.id.to_s)
  end

  it 'allows creating and updating impediments' do
    visit backlogs_project_sprint_taskboard_path(project, sprint)

    find('#impediments .add_new').click

    fill_in 'subject', with: 'New impediment'
    fill_in 'blocks_ids', with: task1.id
    select current_user.name, from: 'assigned_to_id'
    click_on 'OK'

    # Saves successfully
    expect(page)
      .to have_selector('div.impediment', text: 'New impediment')
    expect(page)
      .not_to have_selector('div.impediment.error', text: 'New impediment')

    # Attempt to create a new impediment with the id of a story from another sprint
    find('#impediments .add_new').click

    fill_in 'subject', with: 'Other sprint impediment'
    fill_in 'blocks_ids', with: other_story.id
    click_on 'OK'

    # Saves unsuccessfully
    expect(page)
      .to have_selector('div.impediment', text: 'Other sprint impediment')
    expect(page)
      .to have_selector('div.impediment.error', text: 'Other sprint impediment')
    expect(page)
      .to have_selector('#msgBox',
                        text: "IDs of blocked work packages can only contain IDs of work packages in the current sprint.")

    click_on 'OK'

    # Attempt to create a new impediment with a non existing id
    find('#impediments .add_new').click

    fill_in 'subject', with: 'Invalid id impediment'
    fill_in 'blocks_ids', with: '0'
    click_on 'OK'

    # Saves unsuccessfully
    expect(page)
      .to have_selector('div.impediment', text: 'Invalid id impediment')
    expect(page)
      .to have_selector('div.impediment.error', text: 'Invalid id impediment')
    expect(page)
      .to have_selector('#msgBox',
                        text: "IDs of blocked work packages can only contain IDs of work packages in the current sprint.")
    click_on 'OK'

    # Attempt to create a new impediment without specifying the blocked story/task
    find('#impediments .add_new').click

    fill_in 'subject', with: 'Unblocking impediment'
    click_on 'OK'

    # Saves unsuccessfully
    expect(page)
      .to have_selector('div.impediment', text: 'Unblocking impediment')
    expect(page)
      .to have_selector('div.impediment.error', text: 'Unblocking impediment')
    expect(page)
      .to have_selector('#msgBox', text: "IDs of blocked work packages must contain the ID of at least one ticket")
    click_on 'OK'

    # Updating an impediment
    find('#impediments .subject', text: 'New impediment').click

    fill_in 'subject', with: 'Updated impediment'
    fill_in 'blocks_ids', with: story.id
    click_on 'OK'

    # Saves successfully
    expect(page)
      .to have_selector('div.impediment', text: 'Updated impediment')
    expect(page)
      .not_to have_selector('div.impediment.error', text: 'Updated impediment')
  end
end
