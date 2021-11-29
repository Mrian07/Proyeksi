

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Impediments::UpdateService, type: :model do
  let(:instance) { described_class.new(user: user, impediment: impediment) }

  let(:user) { FactoryBot.create(:user) }
  let(:role) { FactoryBot.create(:role, permissions: %i(edit_work_packages view_work_packages)) }
  let(:type_feature) { FactoryBot.create(:type_feature) }
  let(:type_task) { FactoryBot.create(:type_task) }
  let(:priority) { impediment.priority }
  let(:task) do
    FactoryBot.build(:task, type: type_task,
                            project: project,
                            author: user,
                            priority: priority,
                            status: status1)
  end
  let(:feature) do
    FactoryBot.build(:work_package, type: type_feature,
                                    project: project,
                                    author: user,
                                    priority: priority,
                                    status: status1)
  end
  let(:version) { FactoryBot.create(:version, project: project) }

  let(:project) do
    project = FactoryBot.create(:project, types: [type_feature, type_task])

    FactoryBot.create(:member, principal: user,
                               project: project,
                               roles: [role])

    project
  end

  let(:status1) { FactoryBot.create(:status, name: 'status 1', is_default: true) }
  let(:status2) { FactoryBot.create(:status, name: 'status 2') }
  let(:type_workflow) do
    Workflow.create(type_id: type_task.id,
                    old_status: status1,
                    new_status: status2,
                    role: role)
  end
  let(:impediment) do
    FactoryBot.build(:impediment, author: user,
                                  version: version,
                                  assigned_to: user,
                                  project: project,
                                  type: type_task,
                                  status: status1)
  end

  before(:each) do
    allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'points_burn_direction' => 'down',
                                                                         'wiki_template' => '',
                                                                         'card_spec' => 'Sattleford VM-5040',
                                                                         'story_types' => [type_feature.id.to_s],
                                                                         'task_type' => type_task.id.to_s })

    login_as user

    status1.save
    project.save
    type_workflow.save

    feature.version = version
    feature.save

    impediment.blocks_ids = feature.id.to_s
    impediment.save
  end

  shared_examples_for 'impediment update' do
    it { expect(subject.author).to eql user }
    it { expect(subject.project).to eql project }
    it { expect(subject.version).to eql version }
    it { expect(subject.priority).to eql priority }
    it { expect(subject.status).to eql status2 }
    it { expect(subject.type).to eql type_task }
    it { expect(subject.blocks_ids).to eql blocks.split(/\D+/).map(&:to_i) }
  end

  shared_examples_for 'impediment update with changed blocking relationship' do
    it_should_behave_like 'impediment update'
    it { expect(subject.relations_to.direct.size).to eq(1) }
    it { expect(subject.relations_to.direct[0]).not_to be_new_record }
    it { expect(subject.relations_to.direct[0].to).to eql story }
    it { expect(subject.relations_to.direct[0].relation_type).to eql Relation::TYPE_BLOCKS }
  end

  shared_examples_for 'impediment update with unchanged blocking relationship' do
    it_should_behave_like 'impediment update'
    it { expect(subject.relations_to.direct.size).to eq(1) }
    it { expect(subject.relations_to.direct[0]).not_to be_changed }
    it { expect(subject.relations_to.direct[0].to).to eql feature }
    it { expect(subject.relations_to.direct[0].relation_type).to eql Relation::TYPE_BLOCKS }
  end

  subject do
    call = instance.call(attributes: { blocks_ids: blocks,
                                       status_id: status2.id.to_s })

    call.result
  end

  describe 'WHEN changing the blocking relationship to another story' do
    let(:story) do
      FactoryBot.build(:work_package,
                       subject: 'another story',
                       type: type_feature,
                       project: project,
                       author: user,
                       priority: priority,
                       status: status1)
    end
    let(:blocks) { story.id.to_s }
    let(:story_version) { version }

    before(:each) do
      story.version = story_version
      story.save!
    end

    describe 'WITH the story having the same version' do
      it_should_behave_like 'impediment update with changed blocking relationship'
      it { expect(subject).not_to be_changed }
    end

    describe 'WITH the story having another version' do
      let(:story_version) { FactoryBot.create(:version, project: project, name: 'another version') }

      it_should_behave_like 'impediment update with unchanged blocking relationship'
      it 'should not be saved successfully' do
        expect(subject).to be_changed
      end
      it {
        expect(subject.errors[:blocks_ids]).to include I18n.t(:can_only_contain_work_packages_of_current_sprint,
                                                              scope: %i[activerecord errors models work_package attributes
                                                                        blocks_ids])
      }
    end

    describe 'WITH the story being non existent' do
      let(:blocks) { '0' }

      it_should_behave_like 'impediment update with unchanged blocking relationship'
      it 'should not be saved successfully' do
        expect(subject).to be_changed
      end
      it {
        expect(subject.errors[:blocks_ids]).to include I18n.t(:can_only_contain_work_packages_of_current_sprint,
                                                              scope: %i[activerecord errors models work_package attributes
                                                                        blocks_ids])
      }
    end
  end

  describe 'WITHOUT a blocking relationship defined' do
    let(:blocks) { '' }

    it_should_behave_like 'impediment update with unchanged blocking relationship'
    it 'should not be saved successfully' do
      expect(subject).to be_changed
    end

    it {
      expect(subject.errors[:blocks_ids]).to include I18n.t(:must_block_at_least_one_work_package,
                                                            scope: %i[activerecord errors models work_package attributes
                                                                      blocks_ids])
    }
  end
end