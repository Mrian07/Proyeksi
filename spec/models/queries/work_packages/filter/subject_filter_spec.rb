

require 'spec_helper'

describe Queries::WorkPackages::Filter::SubjectFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:type) { :text }
    let(:class_key) { :subject }

    describe '#available?' do
      it 'is available' do
        expect(instance).to be_available
      end
    end

    describe '#allowed_values' do
      it 'is nil' do
        expect(instance.allowed_values).to be_nil
      end
    end

    describe '#valid_values!' do
      it 'is a noop' do
        instance.values = ['none', 'is', 'changed']

        instance.valid_values!

        expect(instance.values)
          .to match_array ['none', 'is', 'changed']
      end
    end

    it_behaves_like 'non ar filter'
  end
end
