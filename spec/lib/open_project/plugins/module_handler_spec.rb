

require 'spec_helper'
describe OpenProject::Plugins::ModuleHandler do
  let!(:all_former_permissions) { OpenProject::AccessControl.permissions }

  before do
    disabled_modules = OpenProject::Plugins::ModuleHandler.disable_modules('repository')
    OpenProject::Plugins::ModuleHandler.disable(disabled_modules)
  end

  after do
    raise 'Test outdated' unless OpenProject::AccessControl.instance_variable_defined?(:@permissions)

    OpenProject::AccessControl.instance_variable_set(:@permissions, all_former_permissions)
    OpenProject::AccessControl.clear_caches
  end

  context '#disable' do
    it 'should disable repository module' do
      expect(OpenProject::AccessControl.available_project_modules).not_to include(:repository)
    end
  end
end
