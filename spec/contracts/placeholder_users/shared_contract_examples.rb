#-- encoding: UTF-8



require 'spec_helper'

shared_examples_for 'placeholder user contract' do
  let(:placeholder_user_name) { 'UX Designer' }

  context 'when user with global permission' do
    let(:current_user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    it_behaves_like 'contract is valid'
  end

  it_behaves_like 'contract is valid for active admins and invalid for regular users'

  describe 'validations' do
    let(:current_user) { FactoryBot.build_stubbed :admin }
    context 'name' do
      context 'is valid' do
        it_behaves_like 'contract is valid'
      end

      context 'is not too long' do
        let(:placeholder_user) { PlaceholderUser.new(name: 'X' * 257) }

        it_behaves_like 'contract is invalid'
      end

      context 'is not empty' do
        let(:placeholder_user) { PlaceholderUser.new(name: '') }

        it_behaves_like 'contract is invalid'
      end

      context 'is unique' do
        before do
          PlaceholderUser.create(name: placeholder_user_name)
        end

        it_behaves_like 'contract is invalid'
      end
    end

    describe 'type' do
      context 'type and class mismatch' do
        before do
          placeholder_user.type = User.name
        end

        it_behaves_like 'contract is invalid'
      end
    end
  end
end
