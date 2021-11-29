

require 'spec_helper'

shared_examples 'BaseServices delete service' do
  subject(:service_call) { instance.call(call_attributes) }

  let(:service_class) { described_class }
  let(:namespace) { service_class.to_s.deconstantize }
  let(:model_class) { namespace.singularize.constantize }
  let(:contract_class) do
    "#{namespace}::DeleteContract".constantize
  end
  let!(:contract_instance) do
    instance = instance_double(contract_class,
                               valid?: contract_validate_result,
                               validate: contract_validate_result,
                               errors: contract_errors)

    allow(contract_class)
      .to receive(:new)
      .and_return(instance)

    instance
  end
  let(:factory) { namespace.singularize.underscore }

  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) do
    described_class.new(user: user, model: model_instance, contract_class: contract_class)
  end
  let(:call_attributes) { {} }
  let!(:model_instance) { FactoryBot.build_stubbed(factory) }

  let(:model_destroy_result) { true }
  let(:contract_validate_result) { true }
  let(:contract_errors) { ActiveModel::Errors.new(instance) }

  before do
    allow(model_instance).to receive(:destroy).and_return(model_destroy_result)
  end

  describe '#contract' do
    it 'uses the DestroyContract contract' do
      expect(instance.contract_class).to eql contract_class
    end
  end

  describe '#call' do
    context 'when contract validates and the model is destroyed successfully' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'returns the destroyed model as a result' do
        result = subject.result
        expect(result).to eql model_instance
      end
    end

    context 'when contract does not validate' do
      let(:contract_validate_result) { false }

      it 'is unsuccessful' do
        expect(subject).to be_failure
      end

      it 'returns the contract errors' do
        expect(subject.errors)
          .to eql contract_errors
      end
    end

    context 'when model cannot be destroyed' do
      let(:model_destroy_result) { false }
      let(:model_errors) { ActiveModel::Errors.new(model_instance) }

      it 'is unsuccessful' do
        expect(subject)
          .to be_failure
      end

      it "returns the user's errors" do
        model_errors.add :base, 'This is some error.'

        allow(model_instance)
          .to(receive(:errors))
          .and_return model_errors

        expect(subject.errors).to eql model_errors
        expect(subject.errors[:base]).to include "This is some error."
      end
    end
  end
end
