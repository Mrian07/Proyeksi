#-- encoding: UTF-8


require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'
require_relative 'shared_contract_examples'

describe PlaceholderUsers::UpdateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'placeholder user contract' do
    let(:placeholder_user) { FactoryBot.build_stubbed(:placeholder_user, name: placeholder_user_name) }
    let(:contract) { described_class.new(placeholder_user, current_user) }
  end
end
