

require 'spec_helper'
require_relative './shared_contract_examples'
require 'contracts/shared/model_contract_shared_context'


describe Members::UpdateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'member contract' do
    let(:member) do
      FactoryBot.build_stubbed(:member,
                               project: member_project,
                               roles: member_roles,
                               principal: member_principal)
    end

    let(:contract) { described_class.new(member, current_user) }

    describe 'validation' do
      context 'if the principal is changed' do
        before do
          member.principal = FactoryBot.build_stubbed(:user)
        end

        it_behaves_like 'contract is invalid', user_id: :error_readonly
      end

      context 'if the project is changed' do
        before do
          member.project = FactoryBot.build_stubbed(:project)
        end

        it_behaves_like 'contract is invalid', project_id: :error_readonly
      end

      context 'if the principal is a locked user' do
        let(:member_principal) { FactoryBot.build_stubbed(:locked_user) }

        it_behaves_like 'contract is valid'
      end
    end
  end
end
