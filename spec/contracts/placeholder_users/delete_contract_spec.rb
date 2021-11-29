#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe PlaceholderUsers::DeleteContract do
  include_context 'ModelContract shared context'

  let(:placeholder_user) { FactoryBot.create(:placeholder_user) }
  let(:role) { FactoryBot.create :existing_role, permissions: [:manage_members] }
  let(:shared_project) { FactoryBot.create(:project, members: { placeholder_user => role, current_user => role }) }
  let(:not_shared_project) { FactoryBot.create(:project, members: { placeholder_user => role }) }
  let(:contract) { described_class.new(placeholder_user, current_user) }

  it_behaves_like 'contract is valid for active admins and invalid for regular users'

  context 'when user with global permission to manage_placeholders' do
    let(:current_user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    before do
      shared_project
    end

    context 'when user is allowed to manage members in all projects of the placeholder user' do
      it_behaves_like 'contract is valid'
    end

    context 'when user is not allowed to manage members in all projects of the placeholder user' do
      before do
        not_shared_project
      end

      it_behaves_like 'contract user is unauthorized'
    end
  end
end
