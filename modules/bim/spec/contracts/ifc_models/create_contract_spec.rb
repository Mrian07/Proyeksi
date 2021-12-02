#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe Bim::IfcModels::CreateContract do
  it_behaves_like 'ifc model contract' do
    let(:ifc_model) do
      ::Bim::IfcModels::IfcModel.new(project: model_project,
                                     title: model_title,
                                     uploader: model_user).tap do |m|
        m.extend(ProyeksiApp::ChangedBySystem)
        m.changed_by_system("uploader_id" => [nil, model_user.id])
      end
    end
    let(:permissions) { %i(manage_ifc_models) }
    let(:other_user) { FactoryBot.build_stubbed(:user) }

    subject(:contract) do
      described_class.new(ifc_model, current_user, options: {})
    end
  end
end
