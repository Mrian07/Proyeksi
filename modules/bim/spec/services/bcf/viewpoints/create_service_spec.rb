#-- encoding: UTF-8



require 'spec_helper'

describe Bim::Bcf::Viewpoints::CreateService, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:contract_class) do
    double('contract_class', '<=': true)
  end
  let(:viewpoint_valid) { true }
  let(:instance) do
    described_class.new(user: user,
                        contract_class: contract_class)
  end
  let(:call_attributes) do
    {
      "snapshot" =>
        {
          "snapshot_type" => "png",
          "snapshot_data" => "SGVsbG8gV29ybGQh"
        }
    }
  end
  let(:set_attributes_success) do
    true
  end
  let(:set_attributes_errors) do
    double('set_attributes_errors')
  end
  let(:set_attributes_result) do
    ServiceResult.new result: created_viewpoint,
                      success: set_attributes_success,
                      errors: set_attributes_errors
  end
  let!(:created_viewpoint) do
    viewpoint = FactoryBot.build_stubbed(:bcf_viewpoint)

    allow(Bim::Bcf::Viewpoint)
      .to receive(:new)
      .and_return(viewpoint)

    allow(viewpoint)
      .to receive(:save)
      .and_return(viewpoint_valid)

    viewpoint
  end
  let!(:set_attributes_service) do
    service = double('set_attributes_service_instance')

    allow(Bim::Bcf::Viewpoints::SetAttributesService)
      .to receive(:new)
      .with(user: user,
            model: created_viewpoint,
            contract_class: contract_class,
            contract_options: {})
      .and_return(service)

    allow(service)
      .to receive(:call)
      .and_return(set_attributes_result)
  end

  describe '#call' do
    subject { instance.call(call_attributes) }

    it 'is successful' do
      expect(subject.success?).to be_truthy
    end

    it 'returns the result of the SetAttributesService' do
      expect(subject)
        .to eql set_attributes_result
    end

    it 'persists the viewpoint' do
      expect(created_viewpoint)
        .to receive(:save)
        .and_return(viewpoint_valid)

      subject
    end

    it 'returns a viewpoint' do
      expect(subject.result)
        .to eql created_viewpoint
    end

    context 'if the SetAttributeService is unsuccessful' do
      let(:set_attributes_success) { false }

      it 'is unsuccessful' do
        expect(subject.success?).to be_falsey
      end

      it 'returns the result of the SetAttributesService' do
        expect(subject)
          .to eql set_attributes_result
      end

      it 'does not persist the changes' do
        expect(created_viewpoint)
          .to_not receive(:save)

        subject
      end

      it "exposes the contract's errors" do
        subject

        expect(subject.errors).to eql set_attributes_errors
      end
    end

    context 'when the viewpoint is invalid' do
      let(:viewpoint_valid) { false }

      it 'is unsuccessful' do
        expect(subject.success?).to be_falsey
      end

      it "exposes the viewpoint's errors" do
        subject

        expect(subject.errors).to eql created_viewpoint.errors
      end
    end
  end
end
