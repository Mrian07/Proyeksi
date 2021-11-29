

require 'spec_helper'

shared_examples_for 'roles contract' do
  let(:current_user) do
    FactoryBot.build_stubbed(:admin)
  end
  let(:role_instance) { Role.new }
  let(:role_name) { 'A role name' }
  let(:role_assignable) { true }
  let(:role_permissions) { [:view_work_packages] }

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

  describe 'validation' do
    it_behaves_like 'is valid'

    context 'if the name is nil' do
      let(:role_name) { nil }

      it 'is invalid' do
        expect_valid(false, name: %i(blank))
      end
    end

    context 'if the permissions do not include their dependency' do
      let(:role_permissions) { [:manage_members] }

      it 'is invalid' do
        expect_valid(false, permissions: %i(dependency_missing))
      end
    end
  end

  describe '#assignable_permissions' do
    let(:all_permissions) { %i[perm1 perm2 perm3] }

    context 'for a standard role' do
      let(:public_permissions) { [:perm1] }
      let(:global_permissions) { [:perm3] }

      before do
        allow(OpenProject::AccessControl)
          .to receive(:permissions)
          .and_return(all_permissions)
        allow(OpenProject::AccessControl)
          .to receive(:global_permissions)
          .and_return(global_permissions)
        allow(OpenProject::AccessControl)
          .to receive(:public_permissions)
          .and_return(public_permissions)
      end

      it 'is all non public, non global permissions' do
        expect(contract.assignable_permissions)
          .to eql [:perm2]
      end
    end

    context 'for a global role' do
      let(:role) { global_role }

      before do
        allow(OpenProject::AccessControl)
          .to receive(:global_permissions)
          .and_return(all_permissions)
      end

      it 'is all the global permissions' do
        expect(contract.assignable_permissions)
          .to eql all_permissions
      end
    end
  end
end
