#-- encoding: UTF-8



require 'spec_helper'

describe Queries::WorkPackages::Filter::IdFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :id }

    describe '#where' do
      let!(:visible_wp) { FactoryBot.create(:work_package) }
      let!(:other_wp) { FactoryBot.create(:work_package) }

      before do
        instance.values = [visible_wp.id.to_s]
        instance.operator = '='
      end

      it 'filters' do
        expect(WorkPackage.where(instance.where))
          .to match_array [visible_wp]
      end
    end
  end
end
