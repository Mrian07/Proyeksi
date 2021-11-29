

require 'spec_helper'

describe CustomValue::VersionStrategy do
  let(:instance) { described_class.new(custom_value) }
  let(:custom_value) do
    double('CustomValue',
           value: value,
           custom_field: custom_field,
           customized: customized)
  end
  let(:customized) { double('customized') }
  let(:custom_field) { FactoryBot.build(:custom_field) }
  let(:version) { FactoryBot.build_stubbed(:version) }

  describe '#parse_value/#typed_value' do
    subject { instance }

    context 'with a version' do
      let(:value) { version }

      it 'returns the version and sets it for later retrieval' do
        expect(Version)
          .to_not receive(:find_by)

        expect(subject.parse_value(value)).to eql version.id.to_s

        expect(subject.typed_value).to eql value
      end
    end

    context 'with an id string' do
      let(:value) { version.id.to_s }

      it 'returns the string and has to later find the version' do
        allow(Version)
          .to receive(:find_by)
          .with(id: version.id.to_s)
          .and_return(version)

        expect(subject.parse_value(value)).to eql value

        expect(subject.typed_value).to eql version
      end
    end

    context 'value is blank' do
      let(:value) { '' }

      it 'is nil and does not look for the version' do
        expect(Version)
          .to_not receive(:find_by)

        expect(subject.parse_value(value)).to be_nil

        expect(subject.typed_value).to be_nil
      end
    end

    context 'value is nil' do
      let(:value) { nil }

      it 'is nil and does not look for the version' do
        expect(Version)
          .to_not receive(:find_by)

        expect(subject.parse_value(value)).to be_nil

        expect(subject.typed_value).to be_nil
      end
    end
  end

  describe '#formatted_value' do
    subject { instance.formatted_value }

    context 'with a version' do
      let(:value) { version }

      it 'is the version to_s (without db access)' do
        expect(Version)
          .to_not receive(:find_by)

        instance.parse_value(value)

        is_expected.to eql value.to_s
      end
    end

    context 'with an id string' do
      let(:value) { version.id.to_s }

      it 'is the version to_s (with db access)' do
        allow(Version)
          .to receive(:find_by)
          .with(id: version.id.to_s)
          .and_return(version)

        is_expected.to eql version.to_s
      end
    end

    context 'value is blank' do
      let(:value) { '' }

      it 'is blank and does not look for the version' do
        expect(Version)
          .to_not receive(:find_by)

        is_expected.to eql ''
      end
    end

    context 'value is nil' do
      let(:value) { nil }

      it 'is blank and does not look for the version' do
        expect(Version)
          .to_not receive(:find_by)

        is_expected.to eql ''
      end
    end
  end

  describe '#validate_type_of_value' do
    subject { instance.validate_type_of_value }
    let(:allowed_ids) { %w(12 13) }

    before do
      allow(custom_field).to receive(:possible_values).with(customized).and_return(allowed_ids)
    end

    context 'value is id of included element' do
      let(:value) { '12' }
      it 'accepts' do
        is_expected.to be_nil
      end
    end

    context 'value is id of non included element' do
      let(:value) { '10' }
      it 'rejects' do
        is_expected.to eql(:inclusion)
      end
    end
  end
end
