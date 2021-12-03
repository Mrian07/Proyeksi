

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Impediment, type: :model do
  let(:user) { @user ||= FactoryBot.create(:user) }
  let(:role) { @role ||= FactoryBot.create(:role) }
  let(:type_feature) { @type_feature ||= FactoryBot.create(:type_feature) }
  let(:type_task) { @type_task ||= FactoryBot.create(:type_task) }
  let(:issue_priority) { @issue_priority ||= FactoryBot.create(:priority, is_default: true) }
  let(:status) { FactoryBot.create(:status) }
  let(:task) do
    FactoryBot.build(:task, type: type_task,
                            project: project,
                            author: user,
                            priority: issue_priority,
                            status: status)
  end
  let(:feature) do
    FactoryBot.build(:work_package, type: type_feature,
                                    project: project,
                                    author: user,
                                    priority: issue_priority,
                                    status: status)
  end
  let(:version) { FactoryBot.create(:version, project: project) }

  let(:project) do
    unless @project
      @project = FactoryBot.build(:project, types: [type_feature, type_task])
      @project.members = [FactoryBot.build(:member, principal: user,
                                                    project: @project,
                                                    roles: [role])]
    end
    @project
  end

  let(:impediment) do
    FactoryBot.build(:impediment, author: user,
                                  version: version,
                                  assigned_to: user,
                                  priority: issue_priority,
                                  project: project,
                                  type: type_task,
                                  status: status)
  end

  before(:each) do
    allow(Setting)
      .to receive(:plugin_proyeksiapp_backlogs)
      .and_return({ 'points_burn_direction' => 'down',
                    'wiki_template' => '',
                    'card_spec' => 'Sattleford VM-5040',
                    'story_types' => [type_feature.id.to_s],
                    'task_type' => type_task.id.to_s })

    login_as user
  end

  describe 'instance methods' do
    describe 'blocks_ids=/blocks_ids' do
      describe 'WITH an integer' do
        it do
          impediment.blocks_ids = 2
          expect(impediment.blocks_ids).to eql [2]
        end
      end

      describe 'WITH a string' do
        it do
          impediment.blocks_ids = '1, 2, 3'
          expect(impediment.blocks_ids).to eql [1, 2, 3]
        end
      end

      describe 'WITH an array' do
        it do
          impediment.blocks_ids = [1, 2, 3]
          expect(impediment.blocks_ids).to eql [1, 2, 3]
        end
      end

      describe 'WITH only prior blockers defined' do
        before(:each) do
          feature.version = version
          feature.save
          task.version = version
          task.save

          # Using the default association method block_ids (without s) here
          impediment.block_ids = [feature.id, task.id]
        end

        it { expect(impediment.blocks_ids).to eql [feature.id, task.id] }
      end
    end
  end
end
