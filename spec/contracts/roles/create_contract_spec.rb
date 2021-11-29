

require 'spec_helper'
require_relative './shared_contract_examples'

describe Roles::CreateContract do
  it_behaves_like 'roles contract' do
    let(:role) do
      Role.new.tap do |r|
        r.name = role_name
        r.assignable = role_assignable
        r.permissions = role_permissions
      end
    end

    let(:global_role) do
      GlobalRole.new.tap do |r|
        r.name = role_name
        r.permissions = role_permissions
      end
    end

    subject(:contract) { described_class.new(role, current_user) }

    describe 'validation' do
      context 'with the type set manually' do
        before do
          role.type = 'GlobalRole'
        end

        it_behaves_like 'is valid'
      end

      context 'with the type set manually to something other than Role or GlobalRole' do
        before do
          role.type = 'MyRole'
        end

        it 'is invalid' do
          expect_valid(false, type: %i(inclusion))
        end
      end
    end
  end
end
