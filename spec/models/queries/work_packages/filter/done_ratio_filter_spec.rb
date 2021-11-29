

require 'spec_helper'

describe Queries::WorkPackages::Filter::DoneRatioFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :integer }
    let(:class_key) { :done_ratio }

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
  end
end
