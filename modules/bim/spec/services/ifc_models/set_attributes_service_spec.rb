#-- encoding: UTF-8



require 'spec_helper'

describe Bim::IfcModels::SetAttributesService, type: :model do
  shared_let(:project) { FactoryBot.create(:project, enabled_module_names: %i[bim]) }
  shared_let(:other_project) { FactoryBot.create(:project, enabled_module_names: %i[bim]) }
  shared_let(:user) { FactoryBot.create(:user, member_in_project: project, member_with_permissions: %i[manage_ifc_models]) }

  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:contract_class) do
    contract = double('contract_class')

    allow(contract)
      .to receive(:new)
      .with(model, user, options: {})
      .and_return(contract_instance)

    contract
  end
  let(:contract_instance) do
    double('contract_instance', validate: contract_valid, errors: contract_errors)
  end
  let(:contract_valid) { true }
  let(:contract_errors) do
    double('contract_errors')
  end
  let(:model_valid) { true }
  let(:instance) do
    described_class.new(user: user,
                        model: model,
                        contract_class: contract_class)
  end
  let(:call_attributes) { {} }
  let(:ifc_file) { FileHelpers.mock_uploaded_file(name: "model_2.ifc", content_type: 'application/binary', binary: true) }
  let(:model) do
    FactoryBot.create(:ifc_model, project: project, uploader: other_user)
  end

  before do
    # required for the attachments
    login_as(user)
  end

  describe 'call' do
    let(:call_attributes) do
      {
        project_id: other_project.id
      }
    end

    before do
      allow(model)
        .to receive(:valid?)
        .and_return(model_valid)

      expect(contract_instance)
        .to receive(:validate)
        .and_return(contract_valid)
    end

    subject { instance.call(call_attributes) }

    it 'is successful' do
      expect(subject.success?).to be_truthy
    end

    it 'sets the attributes' do
      subject

      expect(model.attributes.slice(*model.changed).symbolize_keys)
        .to eql call_attributes.merge(uploader_id: user.id)
    end

    it 'does not persist the model' do
      expect(model)
        .not_to receive(:save)

      subject
    end

    context 'for a new record' do
      let(:model) do
        Bim::IfcModels::IfcModel.new project: project
      end

      context 'with an ifc_attachment' do
        let(:call_attributes) do
          {
            ifc_attachment: ifc_file
          }
        end

        it 'is successful' do
          expect(subject.success?).to be_truthy
        end

        it 'sets the title to the attachment`s filename' do
          subject

          expect(model.title)
            .to eql 'model_2'
        end

        it 'sets the uploader to the attachment`s author (which is the current user)' do
          subject

          expect(model.uploader)
            .to eql user
        end
      end
    end

    context 'for an existing model' do
      context 'with an ifc_attachment' do
        let(:call_attributes) do
          {
            ifc_attachment: ifc_file
          }
        end

        it 'is successful' do
          expect(subject.success?).to be_truthy
        end

        it 'does not alter the title' do
          title_before = model.title

          subject

          expect(model.title)
            .to eql title_before
        end

        it 'sets the uploader to the attachment`s author (which is the current user)' do
          subject

          expect(model.uploader)
            .to eql user
        end

        it 'marks existing attachments for destruction' do
          ifc_attachment = model.ifc_attachment

          subject

          expect(ifc_attachment)
            .to be_marked_for_destruction
        end
      end
    end
  end
end
