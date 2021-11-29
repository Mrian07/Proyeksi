

require 'spec_helper'

describe CustomValue::StringStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#typed_value' do
    subject { instance.typed_value }

    context 'value is some string' do
      let(:value) { 'foo bar!' }
      it { is_expected.to eql(value) }
    end

    context 'value is blank' do
      let(:value) { '' }
      it { is_expected.to eql(value) }
    end

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#formatted_value' do
    subject { instance.formatted_value }

    context 'value is some string' do
      let(:value) { 'foo bar!' }

      it 'is the string' do
        is_expected.to eql value
      end
    end

    context 'value is blank' do
      let(:value) { '' }

      it 'is a blank string' do
        is_expected.to eql value
      end
    end

    context 'value is nil' do
      let(:value) { nil }

      it 'is a blank string' do
        is_expected.to eql ''
      end
    end
  end

  describe '#validate_type_of_value' do
    subject { instance.validate_type_of_value }

    context 'value is some string' do
      let(:value) { 'foo bar!' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is empty string' do
      let(:value) { '' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end
  end
end
