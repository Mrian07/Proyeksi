#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe Projects::EnabledModulesContract do
  include_context 'ModelContract shared context'

  let(:project) { FactoryBot.build_stubbed(:project, enabled_module_names: enabled_modules) }
  let(:contract) { described_class.new(project, current_user) }
  let(:ac_modules) { [{ name: :a_module, dependencies: %i[b_module] }] }
  let(:current_user) do
    FactoryBot.build_stubbed(:user).tap do |user|
      allow(user)
        .to receive(:allowed_to?) do |requested_permission, requested_project|
        permissions.include?(requested_permission) && requested_project == project
      end
    end
  end
  let(:enabled_modules) { %i[a_module b_module] }
  let(:permissions) { %i[select_project_modules] }

  before do
    allow(OpenProject::AccessControl)
      .to receive(:modules)
      .and_return(ac_modules)
  end

  describe '#valid?' do
    it_behaves_like 'contract is valid'

    context 'when the dependencies are not met' do
      let(:enabled_modules) { %i[a_module] }

      it_behaves_like 'contract is invalid', enabled_modules: :dependency_missing
    end

    context 'when the user lacks the select_project_modules permission' do
      let(:permissions) { %i[] }

      it_behaves_like 'contract is invalid', base: :error_unauthorized
    end
  end
end
