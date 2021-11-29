#-- encoding: UTF-8



require 'spec_helper'

describe ServiceResult, type: :model do
  let(:instance) { ServiceResult.new }

  describe 'success' do
    it 'is what the service is initialized with' do
      instance = ServiceResult.new success: true

      expect(instance.success).to be_truthy
      expect(instance.success?).to be_truthy

      instance = ServiceResult.new success: false

      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end

    it 'returns what is provided' do
      instance.success = true

      expect(instance.success).to be_truthy
      expect(instance.success?).to be_truthy

      instance.success = false

      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end

    it 'is false by default' do
      expect(instance.success).to be_falsey
      expect(instance.success?).to be_falsey
    end
  end

  describe 'errors' do
    let(:errors) { ['errors'] }

    it 'is what has been provided' do
      instance.errors = errors

      expect(instance.errors).to eql errors
    end

    it 'is what the object is initialized with' do
      instance = ServiceResult.new errors: errors

      expect(instance.errors).to eql errors
    end

    it 'is an empty ActiveModel::Errors by default' do
      expect(instance.errors).to be_a ActiveModel::Errors
    end

    context 'providing errors from user' do
      let(:result) { FactoryBot.build :work_package }

      it 'creates a new errors instance' do
        instance = ServiceResult.new result: result
        expect(instance.errors).not_to eq result.errors
      end
    end
  end

  describe 'result' do
    let(:result) { double('result') }

    it 'is what the object is initialized with' do
      instance = ServiceResult.new result: result

      expect(instance.result).to eql result
    end

    it 'is what has been provided' do
      instance.result = result

      expect(instance.result).to eql result
    end

    it 'is nil by default' do
      instance = ServiceResult.new

      expect(instance.result).to be_nil
    end
  end
end
