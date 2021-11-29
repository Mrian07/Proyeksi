

require 'spec_helper'

describe ModelContract do
  let(:model) do
    double('The model',
           child_attribute: nil,
           grand_child_attribute: nil,
           overwritten_attribute: nil,
           changed: [],
           valid?: true,
           errors: ActiveModel::Errors.new(nil))
  end
  let(:child_contract) { ChildContract.new(model, nil) }
  let(:grand_child_contract) { GrandChildContract.new(model, nil) }

  before do
    child_contract.child_value = 0
    grand_child_contract.child_value = 0
  end

  describe 'child' do
    class ChildContract < ModelContract
      attr_accessor :child_value

      attribute :child_attribute
      attribute :overwritten_attribute do
        @child_value = 1
      end
    end

    it 'should collect its own writable attributes' do
      expect(child_contract.writable_attributes).to include('child_attribute',
                                                            'overwritten_attribute')
    end

    it 'should collect its own attribute validations' do
      child_contract.validate
      expect(child_contract.child_value).to eq(1)
    end
  end

  describe 'grand_child' do
    class GrandChildContract < ChildContract
      attr_accessor :grand_child_value

      attribute :grand_child_attribute
      attribute :overwritten_attribute do
        @grand_child_value = 2
      end
    end

    it 'should consider its ancestor writable attributes' do
      expect(grand_child_contract.writable_attributes).to include('child_attribute',
                                                                  'overwritten_attribute',
                                                                  'grand_child_attribute')
    end

    it 'should not contain the same attribute twice, but also has the _id variant' do
      expect(grand_child_contract.writable_attributes.count).to eq(6)
    end

    it 'should execute all the validations' do
      grand_child_contract.validate
      expect(grand_child_contract.child_value).to eq(1)
      expect(grand_child_contract.grand_child_value).to eq(2)
    end
  end
end
