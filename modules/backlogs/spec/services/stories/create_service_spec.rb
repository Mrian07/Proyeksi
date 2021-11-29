

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Stories::CreateService, type: :model do
  let(:priority) { FactoryBot.create(:priority) }
  let(:project) do
    project = FactoryBot.create(:project, types: [type_feature])

    FactoryBot.create(:member,
                      principal: user,
                      project: project,
                      roles: [role])
    project
  end
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i(add_work_packages manage_subtasks assign_versions) }
  let(:status) { FactoryBot.create(:status) }
  let(:type_feature) { FactoryBot.create(:type_feature) }

  let(:user) do
    FactoryBot.create(:user)
  end

  let(:instance) do
    Stories::CreateService
      .new(user: user)
  end

  let(:attributes) do
    {
      project: project,
      status: status,
      type: type_feature,
      priority: priority,
      parent_id: story.id,
      remaining_hours: remaining_hours,
      subject: 'some subject'
    }
  end

  let(:version) { FactoryBot.create(:version, project: project) }

  let(:story) do
    project.enabled_module_names += ['backlogs']

    FactoryBot.create(:story,
                      version: version,
                      project: project,
                      status: status,
                      type: type_feature,
                      priority: priority)
  end

  before do
    allow(User).to receive(:current).and_return(user)
  end

  subject { instance.call(attributes: attributes) }

  describe "remaining_hours" do
    before do
      subject
    end

    context 'with the story having remaining_hours' do
      let(:remaining_hours) { 15.0 }

      it 'does update the parents remaining hours' do
        expect(story.reload.remaining_hours).to eq(15)
      end
    end

    context 'with the subtask not having remaining_hours' do
      let(:remaining_hours) { nil }

      it 'does not note remaining hours to be changed' do
        expect(story.reload.remaining_hours).to be_nil
      end
    end
  end
end
