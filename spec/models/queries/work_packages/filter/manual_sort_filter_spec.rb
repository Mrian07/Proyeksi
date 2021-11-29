#-- encoding: UTF-8



require 'spec_helper'

describe Queries::WorkPackages::Filter::ManualSortFilter, type: :model do
  let!(:in_order) { FactoryBot.create(:work_package) }
  let!(:in_order2) { FactoryBot.create(:work_package) }
  let!(:out_order) { FactoryBot.create(:work_package) }

  let(:ar_double) { double(ActiveRecord::Relation, pluck: [in_order2.id, in_order.id]) }
  let(:query_double) { double(Query, ordered_work_packages: ar_double) }

  let(:instance) do
    described_class.create!(name: :manual_sort, context: query_double, operator: 'ow', values: [])
  end

  describe '#where' do
    it 'filters based on the manual sort order' do
      expect(WorkPackage.where(instance.where))
        .to match_array [in_order2, in_order]
    end
  end
end
