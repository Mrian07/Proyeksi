

require 'spec_helper'

shared_examples_for 'member contract' do
  let(:current_user) do
    FactoryBot.build_stubbed(:user, admin: current_user_admin) do |user|
      allow(user)
        .to receive(:allowed_to?) do |permission, permission_project|
        permissions.include?(permission) && member_project == permission_project
      end
    end
  end
  let(:member_project) do
    FactoryBot.build_stubbed(:project)
  end
  let(:member_roles) do
    [role]
  end
  let(:member_principal) do
    FactoryBot.build_stubbed(:user)
  end
  let(:role) do
    FactoryBot.build_stubbed(:role)
  end
  let(:permissions) { [:manage_members] }
  let(:current_user_admin) { false }

  def expect_valid(valid, symbols = {})
    expect(contract.validate).to eq(valid)

    symbols.each do |key, arr|
      expect(contract.errors.symbols_for(key)).to match_array arr
    end
  end

  describe 'validation' do
    shared_examples 'is valid' do
      it 'is valid' do
        expect_valid(true)
      end
    end

    it_behaves_like 'is valid'

    context 'if the roles are nil' do
      let(:member_roles) { [] }

      it 'is invalid' do
        expect_valid(false, roles: %i(role_blank))
      end
    end

    context 'if any role is not assignable (e.g. builtin)' do
      let(:member_roles) do
        [FactoryBot.build_stubbed(:role), FactoryBot.build_stubbed(:anonymous_role)]
      end

      it 'is invalid' do
        expect_valid(false, roles: %i(ungrantable))
      end
    end

    context 'if the user lacks :manage_members permission in the project' do
      let(:permissions) { [:view_members] }

      it 'is invalid' do
        expect_valid(false, base: %i(error_unauthorized))
      end
    end

    context 'if the project is nil (global membership)' do
      let(:member_project) { nil }
      let(:role) do
        FactoryBot.build_stubbed(:global_role)
      end

      context 'if the user is no admin' do
        it 'is invalid' do
          expect_valid(false, project: %i(blank))
        end
      end

      context 'if the user is admin and the role is global' do
        let(:current_user_admin) { true }

        it_behaves_like 'is valid'
      end

      context 'if the role is not a global role' do
        let(:current_user_admin) { true }
        let(:role) do
          FactoryBot.build_stubbed(:role)
        end

        it 'is invalid' do
          expect_valid(false, roles: %i(ungrantable))
        end
      end
    end

    context 'if the project is set to one not being manageable by the user' do
      let(:permissions) { [] }

      it 'is invalid' do
        expect_valid(false, project: %i(invalid))
      end
    end
  end

  describe 'principal' do
    it 'returns the member\'s principal' do
      expect(contract.principal)
        .to eql(member.principal)
    end
  end

  describe 'project' do
    it 'returns the member\'s project' do
      expect(contract.project)
        .to eql(member.project)
    end
  end
end
