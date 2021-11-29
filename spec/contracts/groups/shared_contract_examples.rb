#-- encoding: UTF-8



require 'spec_helper'

shared_examples_for 'group contract' do
  let(:group_name) { 'The group' }
  let(:group_users_user_ids) { [42, 43] }
  let(:group_users) do
    group_users_user_ids.map { |id| FactoryBot.build_stubbed(:group_user, user_id: id) }
  end

  shared_context 'with real group users' do
    # make sure users actually exist (not just stubbed) in this case
    # so GroupUser validations checking for the existance of group and user don't fail
    before do
      group_users_user_ids.each do |id|
        FactoryBot.create :user, id: id
      end
    end
  end

  it_behaves_like 'contract is valid for active admins and invalid for regular users' do
    include_context 'with real group users'
  end

  describe 'validations' do
    let(:current_user) { FactoryBot.build_stubbed :admin }

    context 'name' do
      context 'is valid' do
        include_context 'with real group users'

        it_behaves_like 'contract is valid'
      end

      context 'is too long' do
        let(:group_name) { 'X' * 257 }

        it_behaves_like 'contract is invalid', name: :too_long
      end

      context 'is not empty' do
        let(:group_name) { '' }

        it_behaves_like 'contract is invalid', name: :blank
      end

      context 'is unique' do
        before do
          Group.create(name: group_name)
        end

        it_behaves_like 'contract is invalid', name: :taken
      end
    end

    context 'groups_users' do
      let(:group_users) do
        [FactoryBot.build_stubbed(:group_user, user_id: 1),
         FactoryBot.build_stubbed(:group_user, user_id: 1)]
      end

      it_behaves_like 'contract is invalid', group_users: :taken
    end
  end
end
