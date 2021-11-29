

require 'spec_helper'

describe CustomValue::FormatStrategy do
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#value_present?' do
    subject { described_class.new(custom_value).value_present? }

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to eql(false) }
    end

    context 'value is empty string' do
      let(:value) { '' }
      it { is_expected.to eql(false) }
    end

    context 'value is present string' do
      let(:value) { 'foo' }
      it { is_expected.to eql(true) }
    end

    context 'value is present integer' do
      let(:value) { 42 }
      it { is_expected.to eql(true) }
    end
  end
end
