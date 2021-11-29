

require 'spec_helper'

describe CustomValue::FloatStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#typed_value' do
    subject { instance.typed_value }

    context 'value is some float string' do
      let(:value) { '3.14' }
      it { is_expected.to eql(3.14) }
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

    context 'value is some float string' do
      let(:value) { '3.14' }

      it 'is the float string' do
        is_expected.to eql value
      end

      it 'is localized' do
        I18n.with_locale(:de) do
          is_expected.to eql '3,14'
        end
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

    context 'value is float string in decimal notation' do
      let(:value) { '3.14' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is float string in exp. notation' do
      let(:value) { '5.0e-14' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is not a float string' do
      let(:value) { 'banana' }
      it 'rejects' do
        is_expected.to eql(:not_a_number)
      end
    end

    context 'value is float' do
      let(:value) { 3.14 }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is int' do
      let(:value) { 3 }
      it 'accepts' do
        # accepting here, as we can "losslessly" convert
        is_expected.to be_nil
      end
    end
  end
end
