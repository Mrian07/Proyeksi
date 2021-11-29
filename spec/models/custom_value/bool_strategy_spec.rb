

require 'spec_helper'

describe CustomValue::BoolStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value)
  end

  describe '#value_present?' do
    subject { described_class.new(custom_value).value_present? }

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to be false }
    end

    context 'value is empty string' do
      let(:value) { '' }
      it { is_expected.to be false }
    end

    context 'value is present string' do
      let(:value) { '1' }
      it { is_expected.to be true }
    end

    context 'value is true' do
      let(:value) { true }
      it { is_expected.to be true }
    end

    context 'value is false' do
      let(:value) { false }
      it { is_expected.to be true }
    end
  end

  describe '#typed_value' do
    subject { instance.typed_value }

    context 'value corresponds to true' do
      let(:value) { '1' }
      it { is_expected.to be true }
    end

    context 'value corresponds to false' do
      let(:value) { '0' }
      it { is_expected.to be false }
    end

    context 'value is blank' do
      let(:value) { '' }
      it { is_expected.to be_nil }
    end

    context 'value is nil' do
      let(:value) { nil }
      it { is_expected.to be_nil }
    end

    context 'value is true' do
      let(:value) { true }
      it { is_expected.to be true }
    end

    context 'value is false' do
      let(:value) { false }
      it { is_expected.to be false }
    end
  end

  describe '#formatted_value' do
    subject { instance.formatted_value }

    context 'value is present string' do
      let(:value) { '1' }

      it 'is the true string' do
        is_expected.to eql I18n.t(:general_text_Yes)
      end
    end

    context 'value is zero string' do
      let(:value) { '0' }

      it 'is the false string' do
        is_expected.to eql I18n.t(:general_text_No)
      end
    end

    context 'value is true' do
      let(:value) { true }

      it 'is the true string' do
        is_expected.to eql I18n.t(:general_text_Yes)
      end
    end

    context 'value is false' do
      let(:value) { false }

      it 'is the false string' do
        is_expected.to eql I18n.t(:general_text_No)
      end
    end

    context 'value is nil' do
      let(:value) { nil }

      it 'is the false string' do
        is_expected.to eql I18n.t(:general_text_No)
      end
    end

    context 'value is blank' do
      let(:value) { '' }

      it 'is the false string' do
        is_expected.to eql I18n.t(:general_text_No)
      end
    end
  end

  describe '#validate_type_of_value' do
    subject { instance.validate_type_of_value }

    context 'value corresponds to true' do
      let(:value) { '1' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value corresponds to false' do
      let(:value) { '0' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is true' do
      let(:value) { true }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is false' do
      let(:value) { false }
      it 'accepts' do
        is_expected.to be_nil
      end
    end
  end

  describe '#parse_value' do
    subject { instance.parse_value(value) }

    ActiveRecord::Type::Boolean::FALSE_VALUES.each do |falsey_value|
      context "for #{falsey_value}" do
        let(:value) { falsey_value }

        it "is 'f'" do
          is_expected.to eql 'f'
        end
      end
    end

    context 'for nil' do
      let(:value) { nil }

      it "is nil" do
        is_expected.to be_nil
      end
    end

    context "for ''" do
      let(:value) { '' }

      it "is nil" do
        is_expected.to be_nil
      end
    end

    [true, '1', 1, 't', 42, 'true'].each do |truthy_value|
      context "for #{truthy_value}" do
        let(:value) { truthy_value }

        it "is 't'" do
          is_expected.to eql 't'
        end
      end
    end
  end
end
