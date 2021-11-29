

require 'spec_helper'

describe Queries::Projects::Filters::VisibleFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :visible }
    let(:type) { :list }
    let(:model) { Project }
    let(:attribute) { :visible }
    let(:values) { ['5'] }

    describe '#available_operators' do
      it 'supports only =' do
        expect(instance.available_operators)
          .to eql [Queries::Operators::Equals]
      end
    end

    describe '#valid?' do
      before do
        allow(User)
          .to receive(:pluck)
                .and_return([[5, 5], [8, 8]])
      end
      context 'without values' do
        let(:values) { [] }

        it 'is invalid' do
          expect(instance)
            .to be_invalid
        end
      end

      context 'with valid value' do
        it 'is valid' do
          expect(instance)
            .to be_valid
        end
      end

      context 'with multiple valid values' do
        let(:values) { %w[5 8] }

        it 'is invalid' do
          expect(instance)
            .to be_invalid
        end
      end
    end
  end
end
