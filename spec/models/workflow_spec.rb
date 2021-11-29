

require 'spec_helper'

describe Workflow, type: :model do
  let(:status_0) { FactoryBot.create(:status) }
  let(:status_1) { FactoryBot.create(:status) }
  let(:role) { FactoryBot.create(:role) }
  let(:type) { FactoryBot.create(:type) }

  describe '#self.copy' do
    let(:role_target) { FactoryBot.create(:role) }
    let(:type_target) { FactoryBot.create(:type) }

    shared_examples_for 'copied workflow' do
      before { Workflow.copy(type, role, type_target, role_target) }

      subject { Workflow.order(Arel.sql('id DESC')).first }

      it { expect(subject.old_status).to eq(workflow_src.old_status) }

      it { expect(subject.new_status).to eq(workflow_src.new_status) }

      it { expect(subject.type_id).to eq(type_target.id) }

      it { expect(subject.role).to eq(role_target) }

      it { expect(subject.author).to eq(workflow_src.author) }

      it { expect(subject.assignee).to eq(workflow_src.assignee) }
    end

    describe 'workflow w/o author or assignee' do
      let!(:workflow_src) do
        FactoryBot.create(:workflow,
                          old_status: status_0,
                          new_status: status_1,
                          type_id: type.id,
                          role: role)
      end
      it_behaves_like 'copied workflow'
    end

    describe 'workflow with author' do
      let!(:workflow_src) do
        FactoryBot.create(:workflow,
                          old_status: status_0,
                          new_status: status_1,
                          type_id: type.id,
                          role: role,
                          author: true)
      end
      it_behaves_like 'copied workflow'
    end

    describe 'workflow with assignee' do
      let!(:workflow_src) do
        FactoryBot.create(:workflow,
                          old_status: status_0,
                          new_status: status_1,
                          type_id: type.id,
                          role: role,
                          assignee: true)
      end
      it_behaves_like 'copied workflow'
    end
  end
end
