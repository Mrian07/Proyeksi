

require 'spec_helper'

describe CustomValue::DateStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#typed_value' do
    subject { instance.typed_value }

    context 'value is some date string' do
      let(:value) { '2015-01-03' }
      it { is_expected.to eql(Date.iso8601(value)) }
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
    subject { instance.formatted_value }

    context 'value is some date string' do
      let(:value) { '2015-01-03' }

      context 'date format', with_settings: { date_format: '%Y-%m-%d' } do
        it 'is the date' do
          is_expected.to eql value
        end
      end
    end

    context 'value is blank' do
      let(:value) { '' }

      it 'is a blank string' do
        is_expected.to eq nil
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

    context 'value is valid date string' do
      let(:value) { '2015-01-03' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is invalid date string in good format' do
      let(:value) { '2015-02-30' }
      it 'rejects' do
        is_expected.to eql(:not_a_date)
      end
    end

    context 'value is date string in bad format' do
      let(:value) { '03.01.2015' }
      it 'rejects' do
        is_expected.to eql(:not_a_date)
      end
    end

    context 'value is not a date string at all' do
      let(:value) { 'chicken' }
      it 'rejects' do
        is_expected.to eql(:not_a_date)
      end
    end

    context 'value is valid date' do
      let(:value) { Date.iso8601('2015-01-03') }
      it 'accepts' do
        is_expected.to be_nil
      end
    end
  end
end
