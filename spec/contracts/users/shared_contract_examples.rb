#-- encoding: UTF-8



require 'spec_helper'

shared_examples_for 'user contract' do
  let(:user_firstname) { 'Bob' }
  let(:user_lastname) { 'Bobbit' }
  let(:user_login) { 'bob' }
  let(:user_mail) { 'bobbit@bob.com' }
  let(:user_password) { 'adminADMIN!' }
  let(:user_password_confirmation) { 'adminADMIN!' }

  it_behaves_like 'contract is valid for active admins and invalid for regular users'

  context 'when admin' do
    let(:current_user) { FactoryBot.build_stubbed :admin }

    it_behaves_like 'contract is valid'
  end

  context 'when global user' do
    let(:current_user) { FactoryBot.create :user, global_permission: :manage_user }

    describe 'cannot set the password' do
      before do
        user.password = user.password_confirmation = 'password!password!'
      end

      it_behaves_like 'contract is invalid', password: :error_readonly
    end

    describe 'can set the auth_source' do
      let!(:auth_source) { FactoryBot.create :auth_source }

      before do
        user.password = user.password_confirmation = nil
        user.auth_source = auth_source
      end

      it_behaves_like 'contract is valid'
    end

    describe 'cannot set the identity url' do
      before do
        user.identity_url = 'saml:123412foo'
      end

      it_behaves_like 'contract is invalid', identity_url: :error_readonly
    end
  end

  context 'when unauthorized user' do
    let(:current_user) { FactoryBot.build_stubbed(:user) }

    it_behaves_like 'contract user is unauthorized'
  end
end
