

require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::EstimatedHours, type: :model do
  let(:key) { :estimated_hours }
  let(:type) { :float_property }
  let(:value) { 1.0 }

  it_behaves_like 'base custom action' do
    describe '#apply' do
      let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package) }

      it 'sets the done_ratio to the action\'s value' do
        instance.values = [95.56]

        instance.apply(work_package)

        expect(work_package.estimated_hours)
          .to eql 95.56
      end
    end

    describe '#multi_value?' do
      it 'is false' do
        expect(instance)
          .not_to be_multi_value
      end
    end

    describe 'validate' do
      let(:errors) do
        FactoryBot.build_stubbed(:custom_action).errors
      end

      it 'is valid for values equal to or greater than 0' do
        instance.values = [50]

        instance.validate(errors)

        expect(errors)
          .to be_empty
      end

      it 'is invalid for values smaller than 0' do
        instance.values = [-0.00001]

        instance.validate(errors)

        expect(errors.symbols_for(:actions))
          .to include(:greater_than_or_equal_to)
      end
    end
  end
end
