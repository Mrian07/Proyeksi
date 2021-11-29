

require 'spec_helper'

describe Queries::Capabilities::Filters::ActionFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :action }
    let(:type) { :string }
    let(:model) { Capability }
    let(:attribute) { :action }
    let(:values) { ['memberships/create'] }

    describe '#available_operators' do
      it 'supports = and !' do
        expect(instance.available_operators)
          .to eql [Queries::Operators::Equals, Queries::Operators::NotEquals]
      end
    end

    describe '#valid?' do
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
        let(:values) { %w[memberships/create users/create] }

        it 'is valid' do
          expect(instance)
            .to be_valid
        end
      end

      context 'with malfomed values' do
        let(:values) { ["foo/5"] }

        it 'is invalid' do
          expect(instance)
            .to be_invalid
        end
      end
    end
  end
end
