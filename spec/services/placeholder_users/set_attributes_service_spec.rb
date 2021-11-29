

require 'spec_helper'

describe PlaceholderUsers::SetAttributesService, type: :model do
  let(:current_user) { FactoryBot.build_stubbed(:user) }

  let(:contract_instance) do
    contract = double('contract_instance')
    allow(contract)
      .to receive(:validate)
      .and_return(contract_valid)
    allow(contract)
      .to receive(:errors)
      .and_return(contract_errors)
    contract
  end

  let(:contract_errors) { double('contract_errors') }
  let(:contract_valid) { true }
  let(:model_valid) { true }

  let(:instance) do
    described_class.new(user: current_user,
                        model: model_instance,
                        contract_class: contract_class,
                        contract_options: {})
  end
  let(:model_instance) { PlaceholderUser.new }
  let(:contract_class) do
    allow(PlaceholderUsers::CreateContract)
      .to receive(:new)
      .and_return(contract_instance)

    PlaceholderUsers::CreateContract
  end

  let(:params) { {} }

  before do
    allow(model_instance)
      .to receive(:valid?)
      .and_return(model_valid)
  end

  subject { instance.call(params) }

  it 'returns the instance as the result' do
    expect(subject.result)
      .to eql model_instance
  end

  it 'is a success' do
    is_expected
      .to be_success
  end

  context 'with params' do
    let(:params) do
      {
        name: 'Foobar'
      }
    end

    it 'assigns the params' do
      subject

      expect(model_instance.name).to eq 'Foobar'
      expect(model_instance.lastname).to eq 'Foobar'
    end
  end

  context 'with an invalid contract' do
    let(:contract_valid) { false }
    let(:expect_time_instance_save) do
      expect(model_instance)
        .not_to receive(:save)
    end

    it 'returns failure' do
      is_expected
        .not_to be_success
    end

    it "returns the contract's errors" do
      expect(subject.errors)
        .to eql(contract_errors)
    end
  end
end
