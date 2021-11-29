

require 'spec_helper'
require_relative '../shared_expectations'

describe CustomActions::Actions::Date, type: :model do
  let(:key) { :date }
  let(:type) { :date_property }
  let(:value) { Date.today }

  it_behaves_like 'base custom action' do
    describe '#apply' do
      let(:work_package) { FactoryBot.build_stubbed(:stubbed_work_package) }

      it 'sets both start and finish date to the action\'s value' do
        instance.values = [Date.today + 5]

        instance.apply(work_package)

        expect(work_package.start_date)
          .to eql Date.today + 5
        expect(work_package.due_date)
          .to eql Date.today + 5
      end

      it 'sets both start and finish date to the current date if so specified' do
        instance.values = ['%CURRENT_DATE%']

        instance.apply(work_package)

        expect(work_package.start_date)
          .to eql Date.today
        expect(work_package.due_date)
          .to eql Date.today
      end
    end

    describe '#multi_value?' do
      it 'is false' do
        expect(instance)
          .not_to be_multi_value
      end
    end
  end
end
