#-- encoding: UTF-8



require 'spec_helper'
require 'services/shared_type_service'

describe UpdateTypeService do
  let(:type) { FactoryBot.build_stubbed(:type) }
  let(:user) { FactoryBot.build_stubbed(:admin) }

  let(:instance) { described_class.new(type, user) }
  let(:service_call) { instance.call(params) }

  let(:valid_group) { { 'type' => 'attribute', 'name' => 'foo', 'attributes' => ['date'] } }

  it_behaves_like 'type service'

  describe "#validate_attribute_groups" do
    let(:params) { { name: 'blubs blubs' } }

    it 'raises an exception for invalid structure' do
      # Example for invalid structure:
      result = instance.call(attribute_groups: ['foo'])
      expect(result.success?).to be_falsey
      # Example for invalid structure:
      result = instance.call(attribute_groups: [[]])
      expect(result.success?).to be_falsey
      # Example for invalid group name:
      result = instance.call(attribute_groups: [['', ['date']]])
      expect(result.success?).to be_falsey
    end

    it 'fails for duplicate group names' do
      result = instance.call(attribute_groups: [valid_group, valid_group])
      expect(result.success?).to be_falsey
      expect(result.errors[:attribute_groups].first).to include 'used more than once.'
    end

    it 'passes validations for known attributes' do
      expect(type).to receive(:save).and_return(true)
      result = instance.call(attribute_groups: [valid_group])
      expect(result.success?).to be_truthy
    end

    it 'passes validation for defaults' do
      expect(type).to be_valid
    end

    it 'passes validation for reset' do
      # A reset is to save an empty Array
      expect(type).to receive(:save).and_return(true)
      result = instance.call(attribute_groups: [])
      expect(result.success?).to be_truthy
      expect(type).to be_valid
    end

    context 'with an invalid query' do
      let(:params) { { attribute_groups: [{ 'type' => 'query', name: 'some name', query: 'wat' }] } }

      it 'is invalid' do
        expect(service_call.success?).to be_falsey
      end
    end
  end
end
