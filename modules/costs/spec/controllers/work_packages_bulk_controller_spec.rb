

require 'spec_helper'

describe WorkPackages::BulkController, type: :controller do
  let(:project) { FactoryBot.create(:project_with_types) }
  let(:controller_role) { FactoryBot.build(:role, permissions: %i[view_work_packages edit_work_packages]) }
  let(:user) { FactoryBot.create :user, member_in_project: project, member_through_role: controller_role }
  let(:budget) { FactoryBot.create :budget, project: project }
  let(:work_package) { FactoryBot.create(:work_package, project: project) }

  before do
    allow(User).to receive(:current).and_return user
  end

  describe '#update' do
    context 'when a cost report is assigned' do
      before do
        put :update, params: { ids: [work_package.id],
                               work_package: { budget_id: budget.id } }
      end

      subject { work_package.reload.budget.try :id }

      it { is_expected.to eq(budget.id) }
    end
  end
end
