

require 'spec_helper'

describe Queries::WorkPackages::Filter::DatesIntervalFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :date }
    let(:class_key) { :dates_interval }

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
  end
end
