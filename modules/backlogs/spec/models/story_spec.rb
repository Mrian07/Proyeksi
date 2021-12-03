

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Story, type: :model do
  let(:user) { @user ||= FactoryBot.create(:user) }
  let(:role) { @role ||= FactoryBot.create(:role) }
  let(:status1) { @status1 ||= FactoryBot.create(:status, name: 'status 1', is_default: true) }
  let(:type_feature) { @type_feature ||= FactoryBot.create(:type_feature) }
  let(:version) { @version ||= FactoryBot.create(:version, project: project) }
  let(:version2) { FactoryBot.create(:version, project: project) }
  let(:sprint) { @sprint ||= FactoryBot.create(:sprint, project: project) }
  let(:issue_priority) { @issue_priority ||= FactoryBot.create(:priority) }
  let(:task_type) { FactoryBot.create(:type_task) }
  let(:task) do
    FactoryBot.create(:story, version: version,
                              project: project,
                              status: status1,
                              type: task_type,
                              priority: issue_priority)
  end
  let(:story1) do
    FactoryBot.create(:story, version: version,
                              project: project,
                              status: status1,
                              type: type_feature,
                              priority: issue_priority)
  end

  let(:story2) do
    FactoryBot.create(:story, version: version,
                              project: project,
                              status: status1,
                              type: type_feature,
                              priority: issue_priority)
  end

  let(:project) do
    unless @project
      @project = FactoryBot.build(:project)
      @project.members = [FactoryBot.build(:member, principal: user,
                                                    project: @project,
                                                    roles: [role])]
    end
    @project
  end

  before(:each) do
    ActionController::Base.perform_caching = false

    allow(Setting).to receive(:plugin_proyeksiapp_backlogs).and_return({ 'points_burn_direction' => 'down',
                                                                         'wiki_template' => '',
                                                                         'card_spec' => 'Sattleford VM-5040',
                                                                         'story_types' => [type_feature.id.to_s],
                                                                         'task_type' => task_type.id.to_s })
    project.types << task_type
  end

  describe 'Class methods' do
    describe '#backlogs' do
      describe "WITH one sprint
                WITH the sprint having 1 story" do
        before(:each) do
          story1
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1]) }
      end

      describe "WITH two sprints
                WITH two stories
                WITH one story per sprint
                WITH querying for the two sprints" do
        before do
          version2
          story1
          story2.version_id = version2.id
          story2.save!
        end

        it { expect(Story.backlogs(project, [version.id, version2.id])[version.id]).to match_array([story1]) }
        it { expect(Story.backlogs(project, [version.id, version2.id])[version2.id]).to match_array([story2]) }
      end

      describe "WITH two sprints
                WITH two stories
                WITH one story per sprint
                WITH querying one sprints" do
        before do
          version2
          story1

          story2.version_id = version2.id
          story2.save!
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1]) }
        it { expect(Story.backlogs(project, [version.id])[version2.id]).to be_empty }
      end

      describe "WITH two sprints
                WITH two stories
                WITH one story per sprint
                WITH querying for the two sprints
                WITH one sprint being in another project" do
        before do
          story1

          other_project = FactoryBot.create(:project)
          version2.update! project_id: other_project.id

          story2.version_id = version2.id
          story2.project = other_project
          # reset memoized versions to reflect changes above
          story2.instance_variable_set('@assignable_versions', nil)
          story2.save!
        end

        it { expect(Story.backlogs(project, [version.id, version2.id])[version.id]).to match_array([story1]) }
        it { expect(Story.backlogs(project, [version.id, version2.id])[version2.id]).to be_empty }
      end

      describe "WITH one sprint
                WITH the sprint having one story in this project and one story in another project" do
        before(:each) do
          version.sharing = 'system'
          version.save!

          another_project = FactoryBot.create(:project)

          story1
          story2.project = another_project
          story2.save!
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1]) }
      end

      describe "WITH one sprint
                WITH the sprint having two storys
                WITH one being the child of the other" do
        before(:each) do
          story1.parent_id = story2.id

          story1.save
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1, story2]) }
      end

      describe "WITH one sprint
                WITH the sprint having one story
                WITH the story having a child task" do
        before(:each) do
          task.parent_id = story1.id

          task.save
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1]) }
      end

      describe "WITH one sprint
                WITH the sprint having one story and one task
                WITH the two having no connection" do
        before(:each) do
          task
          story1
        end

        it { expect(Story.backlogs(project, [version.id])[version.id]).to match_array([story1]) }
      end
    end
  end
end
