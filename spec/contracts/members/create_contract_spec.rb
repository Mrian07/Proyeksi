

require 'spec_helper'
require_relative './shared_contract_examples'
require 'contracts/shared/model_contract_shared_context'

describe Members::CreateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'member contract' do
    let(:member) do
      Member.new(project: member_project,
                 roles: member_roles,
                 principal: member_principal)
    end

    let(:contract) { described_class.new(member, current_user) }

    describe '#validation' do
      context 'if the principal is nil' do
        let(:member_principal) { nil }

        it_behaves_like 'contract is invalid', principal: :blank
      end

      context 'if the principal is a builtin user' do
        let(:member_principal) { FactoryBot.build_stubbed(:anonymous) }

        it_behaves_like 'contract is invalid', principal: :unassignable
      end

      context 'if the principal is a locked user' do
        let(:member_principal) { FactoryBot.build_stubbed(:locked_user) }

        it_behaves_like 'contract is invalid', principal: :unassignable
      end
    end

    describe '#assignable_projects' do
      context 'as a user without permission' do
        let(:current_user) { FactoryBot.build_stubbed :user }

        it 'is empty' do
          expect(contract.assignable_projects).to be_empty
        end
      end

      context 'as a user with permission in one project' do
        let!(:project1) { FactoryBot.create :project }
        let!(:project2) { FactoryBot.create :project }
        let(:current_user) do
          FactoryBot.create :user,
                            member_in_project: project1,
                            member_with_permissions: %i[manage_members]
        end

        it 'returns the one project' do
          expect(contract.assignable_projects.to_a).to eq [project1]
        end
      end
    end
  end
end
