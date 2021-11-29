#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe Projects::ArchiveContract do
  include_context 'ModelContract shared context'

  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:contract) { described_class.new(project, current_user) }

  it_behaves_like 'contract is valid for active admins and invalid for regular users'
end
