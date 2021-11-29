#-- encoding: UTF-8



require 'spec_helper'

shared_examples_for 'ifc model contract' do
  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:model_project) { FactoryBot.build_stubbed(:project) }
  let(:ifc_attachment) { FactoryBot.build_stubbed(:attachment, author: model_user) }
  let(:model_user) { current_user }
  let(:model_title) { 'some title' }

  before do
    allow(ifc_model)
      .to receive(:ifc_attachment)
      .and_return(ifc_attachment)

    allow(other_user)
      .to receive(:allowed_to?) do |permission, permission_project|
      permissions.include?(permission) && model_project == permission_project
    end

    allow(current_user)
      .to receive(:allowed_to?) do |permission, permission_project|
      permissions.include?(permission) && model_project == permission_project
    end
  end

  def expect_valid(valid, symbols = {})
    expect(contract.validate).to eq(valid)

    symbols.each do |key, arr|
      expect(contract.errors.symbols_for(key)).to match_array arr
    end
  end

  shared_examples 'is valid' do
    it 'is valid' do
      expect_valid(true)
    end
  end

  it_behaves_like 'is valid'

  context 'if the title is nil' do
    let(:model_title) { nil }

    it 'is invalid' do
      expect_valid(false, title: %i(blank))
    end
  end

  context 'if the title is blank' do
    let(:model_title) { '' }

    it 'is invalid' do
      expect_valid(false, title: %i(blank))
    end
  end

  context 'if the project is nil' do
    let(:model_project) { nil }

    it 'is invalid' do
      expect_valid(false, project: %i(blank))
    end
  end

  context 'if there is no ifc attachment' do
    let(:ifc_attachment) { nil }

    it 'is invalid' do
      expect_valid(false, base: %i(ifc_attachment_missing))
    end
  end

  context 'if the new ifc file is no valid ifc file' do
    let(:ifc_file) { FileHelpers.mock_uploaded_file name: "model.ifc", content_type: 'application/binary', binary: true }
    let(:ifc_attachment) do
      ::Attachments::BuildService
        .bypass_whitelist(user: current_user)
        .call(file: ifc_file, filename: 'model.ifc')
        .result
    end

    it 'is invalid' do
      expect_valid(false, base: %i(invalid_ifc_file))
    end
  end

  context 'if the new ifc file is a valid ifc file' do
    let(:ifc_file) do
      FileHelpers.mock_uploaded_file name: "model.ifc", content_type: 'application/binary', binary: true, content: "ISO-10303-21;"
    end
    let(:ifc_attachment) do
      ::Attachments::BuildService
        .bypass_whitelist(user: current_user)
        .call(file: ifc_file, filename: 'model.ifc')
        .result
    end

    it_behaves_like 'is valid'
  end

  context 'if user is not allowed to manage ifc models' do
    let(:permissions) { [] }

    it 'is invalid' do
      expect_valid(false, base: %i(error_unauthorized))
    end
  end

  context 'if user of attachment and uploader are different' do
    let(:ifc_attachment) { FactoryBot.build_stubbed(:attachment, author: other_user) }

    it 'is invalid' do
      expect_valid(false, uploader_id: %i(invalid))
    end
  end
end
