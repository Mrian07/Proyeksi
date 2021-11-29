#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'
require_relative 'shared_contract_examples'

describe Groups::UpdateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'group contract' do
    let(:group) do
      FactoryBot.build_stubbed(:group,
                               name: group_name,
                               group_users: group_users)
    end

    let(:contract) { described_class.new(group, current_user) }

    describe 'validations' do
      let(:current_user) { FactoryBot.build_stubbed :admin }

      describe 'type' do
        before do
          group.type = 'A new type'
        end

        it_behaves_like 'contract is invalid', type: :error_readonly
      end
    end
  end
end
