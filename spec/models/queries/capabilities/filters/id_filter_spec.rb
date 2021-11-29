

require 'spec_helper'

describe Queries::Capabilities::Filters::IdFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :id }
    let(:type) { :string }
    let(:model) { Capability }
    let(:attribute) { :id }
    let(:values) { ['memberships/create/p3-5'] }

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
        let(:values) { ['memberships/create/p3-5', 'users/create/g-5'] }

        it 'is valid' do
          expect(instance)
            .to be_valid
        end
      end

      context 'with malfomed values' do
        let(:values) { ["foo/bar/baz-5"] }

        it 'is invalid' do
          expect(instance)
            .to be_invalid
        end
      end
    end
  end
end
