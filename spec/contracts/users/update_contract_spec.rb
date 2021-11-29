#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'
require_relative 'shared_contract_examples'

describe Users::UpdateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'user contract' do
    let(:user) { FactoryBot.build_stubbed(:user, attributes) }
    let(:contract) { described_class.new(user, current_user) }
    let(:attributes) do
      {
        firstname: user_firstname,
        lastname: user_lastname,
        login: user_login,
        mail: user_mail
      }
    end

    describe "validations" do
      describe "#user_allowed_to_update" do
        context "updated user is current user" do
          # That scenario is the only that is not covered by the shared examples
          let(:current_user) { user }

          it_behaves_like 'contract is valid'
        end
      end
    end
  end
end
