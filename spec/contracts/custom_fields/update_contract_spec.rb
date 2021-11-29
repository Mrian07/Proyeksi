#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe CustomFields::UpdateContract do
  include_context 'ModelContract shared context'

  let(:cf) { FactoryBot.build :project_custom_field }
  let(:contract) do
    described_class.new(cf, current_user)
  end

  it_behaves_like 'contract is valid for active admins and invalid for regular users'
end
