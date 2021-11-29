#-- encoding: UTF-8



require 'spec_helper'

shared_examples 'BaseServices create service' do
  let(:service_class) { described_class }
  let(:namespace) { service_class.to_s.deconstantize }
  let(:model_class) { namespace.singularize.constantize }
  let(:contract_class) { "#{namespace}::CreateContract".constantize }
  let(:contract_options) { {} }
  let(:factory) { namespace.singularize.underscore }

  let(:set_attributes_class) { "#{namespace}::SetAttributesService".constantize }

  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:instance) do
    described_class.new(user: user, contract_class: contract_class)
  end
  let(:call_attributes) { { name: 'Some name', identifier: 'Some identifier' } }
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
      .to(receive(:new))
      .with(user: user,
            model: model_instance,
            contract_class: contract_class,
            contract_options: contract_options)
      .and_return(service)

    allow(service)
      .to(receive(:call))
      .and_return(set_attributes_result)

    service
  end

  let(:model_save_result) { true }
  let(:contract_validate_result) { true }

  before do
    allow(model_instance).to receive(:save).and_return(model_save_result)
    allow(instance).to receive(:instance).and_return(model_instance)
  end

  subject { instance.call(call_attributes) }

  describe '#user' do
    it 'exposes a user which is available as a getter' do
      expect(instance.user).to eql user
    end
  end

  describe '#contract' do
    it 'uses the CreateContract contract' do
      expect(instance.contract_class).to eql contract_class
    end
  end

  describe '#call' do
    context 'if contract validates and the model saves' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'matches the set attributes errors' do
        expect(subject.errors).to eq(set_attributes_errors)
      end

      it 'returns the model as a result' do
        result = subject.result
        expect(result).to be_a model_class
      end
    end

    context 'if contract does not validate' do
      let(:set_attributes_success) { false }

      it 'is unsuccessful' do
        expect(subject).to_not be_success
      end
    end

    context 'if model does not save' do
      let(:model_save_result) { false }
      let(:errors) { double('errors') }

      it 'is unsuccessful' do
        expect(subject).to_not be_success
      end

      it "returns the model's errors" do
        allow(model_instance)
          .to(receive(:errors))
          .and_return errors

        expect(subject.errors).to eql errors
      end
    end
  end
end
