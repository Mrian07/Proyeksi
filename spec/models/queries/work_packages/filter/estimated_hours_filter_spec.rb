

require 'spec_helper'

describe Queries::WorkPackages::Filter::EstimatedHoursFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :integer }
    let(:class_key) { :estimated_hours }

    describe '#available?' do
      it 'is true' do
        expect(instance).to be_available
      end
    end

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end

    it_behaves_like 'non ar filter'

    describe '#where' do
      let!(:work_package_zero_hour) { FactoryBot.create(:work_package, estimated_hours: 0) }
      let!(:work_package_no_hours) { FactoryBot.create(:work_package, estimated_hours: nil) }
      let!(:work_package_with_hours) { FactoryBot.create(:work_package, estimated_hours: 1) }

      context 'with the operator being "none"' do
        before do
          instance.operator = Queries::Operators::None.to_sym.to_s
        end
        it 'finds zero and none values' do
          expect(WorkPackage.where(instance.where)).to match_array [work_package_zero_hour, work_package_no_hours]
        end
      end
    end
  end
end
