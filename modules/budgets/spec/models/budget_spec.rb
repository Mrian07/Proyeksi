

require File.dirname(__FILE__) + '/../spec_helper'

describe Budget, type: :model do
  let(:budget) { FactoryBot.build(:budget, project: project) }
  let(:type) { FactoryBot.create(:type_feature) }
  let(:project) { FactoryBot.create(:project_with_types) }
  let(:user) { FactoryBot.create(:user) }

  describe 'destroy' do
    let(:work_package) { FactoryBot.create(:work_package, project: project) }

    before do
      budget.author = user
      budget.work_packages = [work_package]
      budget.save!

      budget.destroy
    end

    it { expect(Budget.find_by_id(budget.id)).to be_nil }
    it { expect(WorkPackage.find_by_id(work_package.id)).to eq(work_package) }
    it { expect(work_package.reload.budget).to be_nil }
  end

  describe '#existing_material_budget_item_attributes=' do
    let!(:existing_material_budget_item) do
      FactoryBot.create(:material_budget_item, budget: budget, units: 10.0)

      budget.material_budget_items.reload.first
    end

    context 'allowed to edit budgets' do
      before do
        allow(User.current)
          .to receive(:allowed_to?)
          .with(:edit_budgets, project)
          .and_return(true)
      end

      context 'with a non integer value' do
        it 'updates the item' do
          budget.existing_material_budget_item_attributes = { existing_material_budget_item.id.to_s => { units: "0.5" } }

          expect(existing_material_budget_item.units)
            .to eql 0.5
        end
      end

      context 'with no value' do
        it 'deletes the item' do
          budget.existing_material_budget_item_attributes = { existing_material_budget_item.id.to_s => {} }

          expect(existing_material_budget_item)
            .to be_destroyed
        end
      end
    end
  end
end
