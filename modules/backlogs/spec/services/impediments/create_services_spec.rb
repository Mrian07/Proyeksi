

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Impediments::CreateService do
  let(:instance) { described_class.new(user: user) }

  let(:user) { FactoryBot.create(:user) }
  let(:role) { FactoryBot.create(:role, permissions: %i(add_work_packages assign_versions)) }
  let(:type_feature) { FactoryBot.create(:type_feature) }
  let(:type_task) { FactoryBot.create(:type_task) }
  let(:priority) { FactoryBot.create(:priority, is_default: true) }
  let(:feature) do
    FactoryBot.build(:work_package,
                     type: type_feature,
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

  before(:each) do
    allow(Setting).to receive(:plugin_proyeksiapp_backlogs).and_return('points_burn_direction' => 'down',
                                                                       'wiki_template' => '',
                                                                       'card_spec' => 'Sattleford VM-5040',
                                                                       'story_types' => [type_feature.id.to_s],
                                                                       'task_type' => type_task.id.to_s)

    login_as user
  end

  let(:impediment_subject) { 'Impediment A' }

  shared_examples_for 'impediment creation' do
    it { expect(subject.subject).to eql impediment_subject }
    it { expect(subject.author).to eql User.current }
    it { expect(subject.project).to eql project }
    it { expect(subject.version).to eql version }
    it { expect(subject.priority).to eql priority }
    it { expect(subject.status).to eql status1 }
    it { expect(subject.type).to eql type_task }
    it { expect(subject.assigned_to).to eql user }
  end

  shared_examples_for 'impediment creation with 1 blocking relationship' do
    it_should_behave_like 'impediment creation'
    it { expect(subject.relations_to.direct.size).to eq(1) }
    it { expect(subject.relations_to.direct[0].to).to eql feature }
    it { expect(subject.relations_to.direct[0].relation_type).to eql Relation::TYPE_BLOCKS }
  end

  shared_examples_for 'impediment creation with no blocking relationship' do
    it_should_behave_like 'impediment creation'
    it { expect(subject.relations_to.direct.size).to eq(0) }
  end

  describe 'WITH a blocking relationship to a story' do
    describe 'WITH the story having the same version' do
      subject do
        call = instance.call(attributes: { subject: impediment_subject,
                                           assigned_to_id: user.id,
                                           priority_id: priority.id,
                                           blocks_ids: feature.id.to_s,
                                           status_id: status1.id,
                                           version_id: version.id,
                                           project_id: project.id })
        call.result
      end

      before(:each) do
        feature.version = version
        feature.save
      end

      it_should_behave_like 'impediment creation with 1 blocking relationship'
      it { expect(subject).not_to be_new_record }
      it { expect(subject.relations_to.direct[0]).not_to be_new_record }
    end

    describe 'WITH the story having another version' do
      subject do
        call = instance.call(attributes: { subject: impediment_subject,
                                           assigned_to_id: user.id,
                                           priority_id: priority.id,
                                           blocks_ids: feature.id.to_s,
                                           status_id: status1.id,
                                           version_id: version.id,
                                           project_id: project.id })
        call.result
      end

      before(:each) do
        feature.version = FactoryBot.create(:version, project: project, name: 'another version')
        feature.save
      end

      it_should_behave_like 'impediment creation with no blocking relationship'
      it { expect(subject).to be_new_record }
      it {
        expect(subject.errors[:blocks_ids]).to include I18n.t(:can_only_contain_work_packages_of_current_sprint,
                                                              scope: %i[activerecord errors models work_package attributes
                                                                        blocks_ids])
      }
    end

    describe 'WITH the story being non existent' do
      subject do
        call = instance.call(attributes: { subject: impediment_subject,
                                           assigned_to_id: user.id,
                                           priority_id: priority.id,
                                           blocks_ids: '0',
                                           status_id: status1.id,
                                           version_id: version.id,
                                           project_id: project.id })
        call.result
      end

      it_should_behave_like 'impediment creation with no blocking relationship'
      it { expect(subject).to be_new_record }
      it {
        expect(subject.errors[:blocks_ids]).to include I18n.t(:can_only_contain_work_packages_of_current_sprint,
                                                              scope: %i[activerecord errors models work_package attributes
                                                                        blocks_ids])
      }
    end
  end

  describe 'WITHOUT a blocking relationship defined' do
    subject do
      call = instance.call(attributes: { subject: impediment_subject,
                                         assigned_to_id: user.id,
                                         blocks_ids: '',
                                         priority_id: priority.id,
                                         status_id: status1.id,
                                         version_id: version.id,
                                         project_id: project.id })
      call.result
    end

    it_should_behave_like 'impediment creation with no blocking relationship'
    it { expect(subject).to be_new_record }
    it {
      expect(subject.errors[:blocks_ids]).to include I18n.t(:must_block_at_least_one_work_package,
                                                            scope: %i[activerecord errors models work_package attributes
                                                                      blocks_ids])
    }
  end
end
