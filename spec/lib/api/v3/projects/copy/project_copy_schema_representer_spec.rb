

require 'spec_helper'

describe ::API::V3::Projects::Copy::ProjectCopySchemaRepresenter do
  include API::V3::Utilities::PathHelper

  shared_let(:current_user, reload: false) { FactoryBot.build_stubbed(:user) }
  shared_let(:source_project, reload: false) { FactoryBot.build_stubbed(:project) }
  shared_let(:contract, reload: false) { ::Projects::CreateContract.new(source_project, current_user) }

  shared_let(:representer, reload: false) do
    described_class.create(contract,
                           self_link: '/a/self/link',
                           form_embedded: true,
                           current_user: current_user)
  end

  shared_let(:subject, reload: false) { representer.to_json }

  describe '_type' do
    it 'is indicated as Schema' do
      is_expected.to be_json_eql('Schema'.to_json).at_path('_type')
    end
  end

  describe 'send_notifications' do
    it_behaves_like 'has basic schema properties' do
      let(:path) { "sendNotifications" }
      let(:type) { 'Boolean' }
      let(:name) { I18n.t(:label_project_copy_notifications) }
      let(:required) { false }
      let(:has_default) { true }
      let(:writable) { true }
      let(:location) { '_meta' }
    end
  end

  describe 'copy properties' do
    ::Projects::CopyService.copyable_dependencies.each do |dep|
      it_behaves_like 'has basic schema properties' do
        let(:path) { "copy#{dep[:identifier].camelize}" }
        let(:type) { 'Boolean' }
        let(:name) { dep[:name_source].call }
        let(:required) { false }
        let(:has_default) { true }
        let(:writable) { true }
        let(:location) { '_meta' }
        let(:description) { "No objects of this type" }
      end
    end
  end
end
