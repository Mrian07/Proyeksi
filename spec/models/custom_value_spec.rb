

require 'spec_helper'

describe CustomValue do
  let(:format) { 'bool' }
  let(:custom_field) { FactoryBot.create(:custom_field, field_format: format) }
  let(:custom_value) { FactoryBot.create(:custom_value, custom_field: custom_field, value: value) }

  describe '#typed_value' do
    subject { custom_value }

    before do
      # we are testing roundtrips through the database here
      # the databases might choose to store values in weird and unexpected formats (e.g. booleans)
      subject.reload
    end

    describe 'boolean custom value' do
      let(:format) { 'bool' }
      let(:value) { true }

      context 'is true' do
        it { expect(subject.typed_value).to eql(value) }
      end

      context 'is false' do
        let(:value) { false }

        it { expect(subject.typed_value).to eql(value) }
      end

      context 'is nil' do
        let(:value) { nil }

        it { expect(subject.typed_value).to eql(value) }
      end
    end

    describe 'integer custom value' do
      let(:format) { 'string' }
      let(:value) { 'This is a string!' }

      it { expect(subject.typed_value).to eql(value) }
    end

    describe 'integer custom value' do
      let(:format) { 'int' }
      let(:value) { 123 }

      it { expect(subject.typed_value).to eql(value) }
    end

    describe 'float custom value' do
      let(:format) { 'float' }
      let(:value) { 3.147 }

      it { expect(subject.typed_value).to eql(value) }
    end

    describe 'date custom value' do
      let(:format) { 'date' }
      let(:value) { Date.new(2016, 12, 1) }

      it { expect(subject.typed_value).to eql(value) }

      context 'date format', with_settings: { date_format: '%Y/%m/%d' } do
        it { expect(subject.formatted_value).to eq('2016/12/01') }
      end
    end
  end

  describe 'trying to use a custom field that does not exist' do
    subject { FactoryBot.build(:custom_value, custom_field_id: 123412341, value: 'my value') }

    it 'returns an empty placeholder' do
      expect(subject.custom_field).to be_nil
      expect(subject.send(:strategy)).to be_kind_of CustomValue::EmptyStrategy
      expect(subject.typed_value).to eq 'my value not found'
      expect(subject.formatted_value).to eq 'my value not found'
    end
  end

  describe 'value/value=' do
    let(:custom_value) { FactoryBot.build_stubbed(:custom_value) }
    let(:strategy_double) { double('strategy_double') }

    it 'calls the strategy for parsing and uses that value' do
      original_value = 'original value'
      parsed_value = 'parsed value'

      allow(custom_value)
        .to receive(:strategy)
        .and_return(strategy_double)

      allow(strategy_double)
        .to receive(:parse_value)
        .with(original_value)
        .and_return(parsed_value)

      custom_value.value = original_value

      expect(custom_value.value).to eql parsed_value
    end
  end
end
