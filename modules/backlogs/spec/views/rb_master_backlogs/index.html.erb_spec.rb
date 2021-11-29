

require File.dirname(__FILE__) + '/../../spec_helper'

describe 'rb_master_backlogs/index', type: :view do
  let(:user) { FactoryBot.create(:user) }
  let(:role_allowed) do
    FactoryBot.create(:role,
                      permissions: %i[view_master_backlog view_taskboards])
  end
  let(:statuses) do
    [FactoryBot.create(:status, is_default: true),
     FactoryBot.create(:status),
     FactoryBot.create(:status)]
  end
  let(:type_task) { FactoryBot.create(:type_task) }
  let(:type_feature) { FactoryBot.create(:type_feature) }
  let(:issue_priority) { FactoryBot.create(:priority) }
  let(:project) do
    project = FactoryBot.create(:project, types: [type_feature, type_task])
    project.members = [FactoryBot.create(:member, principal: user, project: project, roles: [role_allowed])]
    project
  end
  let(:story_a) do
    FactoryBot.create(:story, status: statuses[0],
                              project: project,
                              type: type_feature,
                              version: sprint,
                              priority: issue_priority)
  end
  let(:story_b) do
    FactoryBot.create(:story, status: statuses[1],
                              project: project,
                              type: type_feature,
                              version: sprint,
                              priority: issue_priority)
  end
  let(:story_c) do
    FactoryBot.create(:story, status: statuses[2],
                              project: project,
                              type: type_feature,
                              version: sprint,
                              priority: issue_priority)
  end
  let(:stories) { [story_a, story_b, story_c] }
  let(:sprint) { FactoryBot.create(:sprint, project: project) }

  before :each do
    allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'story_types' => [type_feature.id],
                                                                         'task_type' => type_task.id })
    view.extend RbCommonHelper
    view.extend RbMasterBacklogsHelper
    allow(view).to receive(:current_user).and_return(user)

    assign(:project, project)
    assign(:sprint, sprint)
    assign(:owner_backlogs, Backlog.owner_backlogs(project))
    assign(:sprint_backlogs, Backlog.sprint_backlogs(project))

    allow(User).to receive(:current).and_return(user)

    # We directly force the creation of stories by calling the method
    stories
  end

  it 'shows link to export with the default export card configuration' do
    default_export_card_config = FactoryBot.create(:export_card_configuration)
    assign(:export_card_config_meta, {
             default: default_export_card_config,
             count: 1
           })

    render

    assert_select '.menu ul.items a' do |a|
      url = backlogs_project_sprint_export_card_configuration_path(project.identifier, sprint.id, default_export_card_config.id,
                                                                   format: :pdf)
      expect(a.last).to have_content 'Export'
      expect(a.last).to have_css("a[href='#{url}']")
    end
  end

  it 'shows link to display export card configuration choice modal' do
    assign(:export_card_config_meta, { count: 2 })
    render

    assert_select '.menu ul.items a' do |a|
      url = backlogs_project_sprint_export_card_configurations_path(project.id, sprint.id)
      expect(a.last).to have_content 'Export'
      expect(a.last).to have_css("a[href='#{url}']")
      expect(a.last).to have_css('a[data-modal]')
    end
  end
end
