

require 'spec_helper'
require_relative './shared_contract_examples'

describe Roles::UpdateContract do
  it_behaves_like 'roles contract' do
    let(:role) do
      FactoryBot.build_stubbed(:role,
                               name: 'Some name',
                               assignable: !role_assignable).tap do |r|
        r.name = role_name
        r.assignable = role_assignable
        r.permissions = role_permissions
      end
    end

    let(:global_role) do
      FactoryBot.build_stubbed(:global_role,
                               name: 'Some name').tap do |r|
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

        it 'is invalid' do
          expect_valid(false, type: %i(error_readonly))
        end
      end
    end
  end
end
