#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe Bim::IfcModels::UpdateContract do
  it_behaves_like 'ifc model contract' do
    subject(:contract) { described_class.new(ifc_model, current_user) }

    let(:ifc_model) do
      FactoryBot.build_stubbed(:ifc_model,
                               uploader: model_user,
                               title: model_title,
                               project: model_project).tap do |model|
        model.extend(OpenProject::ChangedBySystem)

        if changed_by_system
          changed_by_system do
            model.uploader = uploader_user
          end
        else
          model.uploader = uploader_user
        end
      end
    end
    let(:permissions) { %i(manage_ifc_models) }
    let(:uploader_user) { model_user }
    let(:changed_by_system) { false }

    context 'if the uploader changes' do
      let(:model_user) { FactoryBot.build_stubbed(:user) }
      let(:uploader_user) { other_user }
      let(:current_user) { other_user }
      let(:ifc_attachment) { FactoryBot.build_stubbed(:attachment, author: other_user) }

      it 'is invalid as not writable' do
        expect_valid(false, uploader_id: %i(error_readonly))
      end
    end

    context 'if the uploader changes' do
      let(:model_user) { FactoryBot.build_stubbed(:user) }
      let(:uploader_user) { other_user }
      let(:current_user) { other_user }
      let(:ifc_attachment) { FactoryBot.build_stubbed(:attachment, author: other_user) }
      let(:changed_by_system) { true }

      it 'is invalid as does not match' do
        expect_valid(false, uploader_id: %i(invalid))
      end
    end

    context 'if the uploader does not change and the current user is different from the uploader' do
      let(:current_user) { other_user }
      let(:model_user) { FactoryBot.build_stubbed(:user) }

      it_behaves_like 'is valid'
    end
  end
end
