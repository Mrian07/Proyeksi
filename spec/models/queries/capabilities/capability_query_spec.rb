

require 'spec_helper'

describe Queries::Capabilities::CapabilityQuery, type: :model do
  let(:instance) { described_class.new }

  current_user do
    FactoryBot.build_stubbed(:user)
  end

  describe '#valid?' do
    context 'without filters' do
      it 'is invalid' do
        expect(instance)
          .not_to be_valid
      end
    end

    context 'with a principal filter having the `=` operator' do
      before do
        instance.where('principal_id', '=', ['1'])
      end

      it 'is valid' do
        expect(instance)
          .to be_valid
      end
    end

    context 'with a principal filter having the `!` operator' do
      before do
        instance.where('principal_id', '!', ['1'])
      end

      it 'is invalid' do
        expect(instance)
          .not_to be_valid
      end
    end

    context 'with a principal filter having the `=` operator but without values' do
      before do
        instance.where('principal_id', '=', [])
      end

      it 'is invalid' do
        expect(instance)
          .not_to be_valid
      end
    end

    context 'with a context filter having the `=` operator' do
      before do
        instance.where('context', '=', ['p1'])
      end

      it 'is valid' do
        expect(instance)
          .to be_valid
      end
    end

    context 'with a context filter having the `=` operator but without values' do
      before do
        instance.where('context', '=', [])
      end

      it 'is invalid' do
        expect(instance)
          .not_to be_valid
      end
    end

    context 'with a context filter having the `!` operator' do
      before do
        instance.where('context', '!', ['g'])
      end

      it 'is invalid' do
        expect(instance)
          .not_to be_valid
      end
    end

    context 'with a context filter having the `!` operator and also with a principal filter having the `=` operator' do
      before do
        instance.where('context', '!', ['g'])
        instance.where('principal_id', '=', ['1'])
      end

      it 'is valid' do
        expect(instance)
          .to be_valid
      end
    end
  end
end
