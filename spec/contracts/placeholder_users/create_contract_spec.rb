#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'
require_relative 'shared_contract_examples'

describe PlaceholderUsers::CreateContract do
  include_context 'ModelContract shared context'

  context 'without enterprise' do
    let(:placeholder_user) { PlaceholderUser.new(name: 'foo') }
    let(:contract) { described_class.new(placeholder_user, current_user) }

    context 'when user with global permission' do
      let(:current_user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

      it_behaves_like 'contract is invalid', base: :error_enterprise_only
    end

    context 'when user with admin permission' do
      let(:current_user) { FactoryBot.build_stubbed(:admin) }

      it_behaves_like 'contract is invalid', base: :error_enterprise_only
    end
  end

  context 'with enterprise', with_ee: %i[placeholder_users] do
    it_behaves_like 'placeholder user contract' do
      let(:placeholder_user) { PlaceholderUser.new(name: placeholder_user_name) }
      let(:contract) { described_class.new(placeholder_user, current_user) }
    end
  end
end
