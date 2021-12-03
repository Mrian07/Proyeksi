

require 'spec_helper'
describe ProyeksiApp::Plugins::ModuleHandler do
  let!(:all_former_permissions) { ProyeksiApp::AccessControl.permissions }

  before do
    disabled_modules = ProyeksiApp::Plugins::ModuleHandler.disable_modules('repository')
    ProyeksiApp::Plugins::ModuleHandler.disable(disabled_modules)
  end

  after do
    raise 'Test outdated' unless ProyeksiApp::AccessControl.instance_variable_defined?(:@permissions)

    ProyeksiApp::AccessControl.instance_variable_set(:@permissions, all_former_permissions)
    ProyeksiApp::AccessControl.clear_caches
  end

  context '#disable' do
    it 'should disable repository module' do
      expect(ProyeksiApp::AccessControl.available_project_modules).not_to include(:repository)
    end
  end
end
