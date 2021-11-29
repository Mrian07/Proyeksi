#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'
require_relative 'shared_contract_examples'

describe Users::CreateContract do
  include_context 'ModelContract shared context'

  it_behaves_like 'user contract' do
    let(:user) { User.new(attributes) }
    let(:contract) { described_class.new(user, current_user) }
    let(:attributes) do
      {
        firstname: user_firstname,
        lastname: user_lastname,
        login: user_login,
        mail: user_mail,
        password: user_password,
        password_confirmation: user_password_confirmation
      }
    end

    context 'when admin' do
      let(:current_user) { FactoryBot.build_stubbed(:admin) }

      it_behaves_like 'contract is valid'

      describe 'requires a password set when active' do
        before do
          user.password = nil
          user.password_confirmation = nil
          user.activate
        end

        it_behaves_like 'contract is invalid', password: :blank

        context 'when password is set' do
          before do
            user.password = user.password_confirmation = 'password!password!'
          end

          it_behaves_like 'contract is valid'
        end
      end
    end
  end
end
