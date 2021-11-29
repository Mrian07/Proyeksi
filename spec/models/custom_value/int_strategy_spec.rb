

require 'spec_helper'

describe CustomValue::IntStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#typed_value' do
    subject { instance.typed_value }

    context 'value is some float string' do
      let(:value) { '10' }
      it { is_expected.to eql(10) }
    end

    context 'value is blank' do
      let(:value) { '' }
      it { is_expected.to be_nil }
    end

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#formatted_value' do
    subject { instance.typed_value }

    context 'value is some int string' do
      let(:value) { '10' }
      it { is_expected.to eql(10) }
    end

    context 'value is blank' do
      let(:value) { '' }
      it { is_expected.to be_nil }
    end

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to be_nil }
    end
  end

  describe '#validate_type_of_value' do
    subject { instance.validate_type_of_value }

    context 'value is positive int string' do
      let(:value) { '10' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is negative int string' do
      let(:value) { '-10' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is not an int string' do
      let(:value) { 'unicorn' }
      it 'rejects' do
        is_expected.to eql(:not_an_integer)
      end
    end

    context 'value is an actual int' do
      let(:value) { 10 }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is a float' do
      let(:value) { 2.3 }
      it 'rejects' do
        is_expected.to eql(:not_an_integer)
      end
    end
  end
end
