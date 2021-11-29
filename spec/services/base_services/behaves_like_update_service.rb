#-- encoding: UTF-8



require 'spec_helper'

shared_examples 'BaseServices update service' do
  let(:service_class) { described_class }
  let(:namespace) { service_class.to_s.deconstantize }
  let(:model_class) { namespace.singularize.constantize }
  let(:contract_class) { "#{namespace}::UpdateContract".constantize }
  let(:factory) { namespace.singularize.underscore }

  let(:set_attributes_class) { "#{namespace}::SetAttributesService".constantize }

  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:contract_class) do
    double('contract_class', '<=': true)
  end
  let(:instance) do
    described_class.new(user: user,
                        model: model_instance,
                        contract_class: contract_class)
  end
  let(:call_attributes) { { some: 'hash'} }
  let(:set_attributes_success) do
    true
  end
  let(:set_attributes_errors) do
    double('set_attributes_errors')
  end
  let(:set_attributes_result) do
    ServiceResult.new result: model_instance,
                      success: set_attributes_success,
                      errors: set_attributes_errors
  end
  let!(:model_instance) { FactoryBot.build_stubbed(factory) }
  let!(:set_attributes_service) do
    service = double('set_attributes_service_instance')

    allow(set_attributes_class)
      .to receive(:new)
      .with(user: user,
            model: model_instance,
            contract_class: contract_class,
            contract_options: {})
      .and_return(service)

    allow(service)
      .to receive(:call)
      .and_return(set_attributes_result)
  end

  let(:model_save_result) { true }

  before do
    allow(model_instance).to receive(:save).and_return(model_save_result)
  end

  subject(:instance_call) { instance.call(call_attributes) }

  describe '#user' do
    it 'exposes a user which is available as a getter' do
      expect(instance.user).to eql user
    end
  end

  describe '#contract' do
    it 'uses the UpdateContract contract' do
      expect(instance.contract_class).to eql contract_class
    end
  end

  describe "#call" do
    context 'when the model instance is valid' do
      it 'is a successful call', :aggregate_failures do
        expect(subject).to be_success
        expect(subject).to eql set_attributes_result
        expect(subject.result).to eql model_instance
      end
    end

    context 'if the SetAttributeService is unsuccessful' do
      let(:set_attributes_success) { false }

      it 'is unsuccessful', :aggregate_failures do
        expect(model_instance).not_to receive(:save)

        expect(subject).to be_failure
        expect(subject).to eql set_attributes_result

        expect(model_instance).to_not receive(:save)

        expect(subject.errors).to eql set_attributes_errors
      end
    end

    context 'when the model instance is invalid' do
      let(:model_save_result) { false }

      it 'is unsuccessful and returns the errors', :aggregate_failures do
        expect(subject).to be_failure
        expect(subject.errors).to eql model_instance.errors
      end
    end
  end
end
