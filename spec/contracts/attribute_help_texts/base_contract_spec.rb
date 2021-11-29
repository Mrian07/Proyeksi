

require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe AttributeHelpTexts::BaseContract do
  include_context 'ModelContract shared context'

  let(:model) { FactoryBot.build_stubbed :work_package_help_text }
  let(:contract) { described_class.new(model, current_user) }

  it_behaves_like 'contract is valid for active admins and invalid for regular users'
end
