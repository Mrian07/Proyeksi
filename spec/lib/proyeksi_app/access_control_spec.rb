

require 'spec_helper'

describe ProyeksiApp::AccessControl do
  def stash_access_control_permissions
    @stashed_permissions = ProyeksiApp::AccessControl.permissions.dup
    ProyeksiApp::AccessControl.clear_caches
    ProyeksiApp::AccessControl.instance_variable_get(:@permissions).clear
  end

  def restore_access_control_permissions
    ProyeksiApp::AccessControl.instance_variable_set(:@permissions, @stashed_permissions)
    ProyeksiApp::AccessControl.clear_caches
  end

  def setup_global_permissions
    ProyeksiApp::AccessControl.map do |map|
      map.permission :proj0, { dont: :care }, require: :member, contract_actions: { foo: :create }
      map.permission :global0, { dont: :care }, global: true
      map.permission :proj1, { dont: :care }

      map.project_module :global_module do |mod|
        mod.permission :global1, { dont: :care }, global: true
      end

      map.project_module :project_module do |mod|
        mod.permission :proj2, { dont: :care }, contract_actions: { bar: %i[create read] }
      end

      map.project_module :mixed_module do |mod|
        mod.permission :proj3, { dont: :care }
        mod.permission :global2, { dont: :care }, global: true, contract_actions: { baz: %i[destroy] }
      end

      map.project_module :dependent_module, dependencies: :project_module do |mod|
        mod.permission :proj4, { dont: :care }
      end
    end
  end

  describe '.remove_modules_permissions' do
    let!(:all_former_permissions) { ProyeksiApp::AccessControl.permissions }
    let!(:former_repository_permissions) do
      module_permissions = ProyeksiApp::AccessControl.modules_permissions(['repository'])

      module_permissions.select do |permission|
        permission.project_module == :repository
      end
    end

    subject { ProyeksiApp::AccessControl }

    before do
      ProyeksiApp::AccessControl.remove_modules_permissions(:repository)
    end

    after do
      raise 'Test outdated' unless ProyeksiApp::AccessControl.instance_variable_defined?(:@permissions)

      ProyeksiApp::AccessControl.instance_variable_set(:@permissions, all_former_permissions)
      ProyeksiApp::AccessControl.clear_caches
    end

    it 'removes from global permissions' do
      expect(subject.permissions).not_to include(former_repository_permissions)
    end

    it 'removes from public permissions' do
      expect(subject.public_permissions).not_to include(former_repository_permissions)
    end

    it 'removes from members only permissions' do
      expect(subject.members_only_permissions).not_to include(former_repository_permissions)
    end

    it 'removes from loggedin only permissions' do
      expect(subject.loggedin_only_permissions).not_to include(former_repository_permissions)
    end

    it 'should disable repository module' do
      expect(subject.available_project_modules).not_to include(:repository)
    end
  end

  describe '#permissions' do
    it 'is an array of permissions' do
      expect(described_class.permissions)
        .to(be_all{ |p| p.is_a?(ProyeksiApp::AccessControl::Permission) })
    end
  end

  describe '#permission' do
    context 'for a project module permission' do
      subject { described_class.permission(:view_work_packages) }

      it 'is a permission' do
        is_expected
          .to be_a(ProyeksiApp::AccessControl::Permission)
      end

      it 'is the permission with the queried for name' do
        expect(subject.name)
          .to eql(:view_work_packages)
      end

      it 'belongs to a project module' do
        expect(subject.project_module)
          .to eql(:work_package_tracking)
      end
    end

    context 'for a non module permission' do
      subject { described_class.permission(:edit_project) }

      it 'is a permission' do
        is_expected
          .to be_a(ProyeksiApp::AccessControl::Permission)
      end

      it 'is the permission with the queried for name' do
        expect(subject.name)
          .to eql(:edit_project)
      end

      it 'belongs to a project module' do
        expect(subject.project_module)
          .to be_nil
      end

      it 'includes actions' do
        expect(subject.controller_actions)
          .to include('projects/settings/general/show')
      end
    end
  end

  describe '#dependencies' do
    context 'for a permission with a prerequisite' do
      subject { described_class.permission(:edit_work_packages) }

      it 'denotes the prerequiresites' do
        expect(subject.dependencies)
          .to match_array([:view_work_packages])
      end
    end

    context 'for a permission without a prerequisite' do
      subject { described_class.permission(:view_work_packages) }

      it 'denotes the prerequiresites' do
        expect(subject.dependencies)
          .to be_empty
      end
    end
  end

  describe '.modules' do
    before do
      stash_access_control_permissions

      setup_global_permissions
    end

    after do
      restore_access_control_permissions
    end

    it 'can store dependencies' do
      expect(ProyeksiApp::AccessControl.modules.detect { |m| m[:name] == :dependent_module }[:dependencies])
        .to match_array(%i[project_module])
    end
  end

  describe '#global_permissions' do
    before do
      stash_access_control_permissions

      setup_global_permissions
    end

    after do
      restore_access_control_permissions
    end

    it { expect(ProyeksiApp::AccessControl.global_permissions.size).to eq(3) }
    it { expect(ProyeksiApp::AccessControl.global_permissions.collect(&:name)).to include(:global0) }
    it { expect(ProyeksiApp::AccessControl.global_permissions.collect(&:name)).to include(:global1) }
    it { expect(ProyeksiApp::AccessControl.global_permissions.collect(&:name)).to include(:global2) }
  end

  describe '.available_project_modules' do
    before do
      stash_access_control_permissions

      setup_global_permissions
    end

    after do
      restore_access_control_permissions
    end

    it { expect(ProyeksiApp::AccessControl.available_project_modules).not_to include(:global_module) }
    it { expect(ProyeksiApp::AccessControl.available_project_modules).to include(:mixed_module) }
  end

  describe '#contract_actions_map' do
    before do
      stash_access_control_permissions

      setup_global_permissions
    end

    after do
      restore_access_control_permissions
    end

    it 'contains all contract actions grouped by the permission' do
      expect(subject.contract_actions_map)
        .to eql(global2: { actions: { baz: [:destroy] }, global: true, module: :mixed_module },
                proj0: { actions: { foo: :create }, global: false, module: nil },
                proj2: { actions: { bar: %i[create read] }, global: false, module: :project_module })
    end
  end
end
