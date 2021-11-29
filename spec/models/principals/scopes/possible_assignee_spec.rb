#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::PossibleAssignee, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:other_project) { FactoryBot.create(:project) }
  let(:role_assignable) { true }
  let(:role) { FactoryBot.create(:role, assignable: role_assignable) }
  let(:user_status) { :active }
  let!(:member_user) do
    FactoryBot.create(:user,
                      status: user_status,
                      member_in_project: project,
                      member_through_role: role)
  end
  let!(:member_placeholder_user) do
    FactoryBot.create(:placeholder_user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let!(:member_group) do
    FactoryBot.create(:group,
                      member_in_project: project,
                      member_through_role: role)
  end
  let!(:other_project_member_user) do
    FactoryBot.create(:group,
                      member_in_project: other_project,
                      member_through_role: role)
  end

  describe '.possible_assignee' do
    subject { Principal.possible_assignee(project) }

    context 'with the role being assignable' do
      context 'with the user status being active' do
        it 'returns non locked users, groups and placeholder users that are members' do
          is_expected
            .to match_array([member_user,
                             member_placeholder_user,
                             member_group])
        end
      end

      context 'with the user status being registered' do
        let(:user_status) { :registered }

        it 'returns non locked users, groups and placeholder users that are members' do
          is_expected
            .to match_array([member_user,
                             member_placeholder_user,
                             member_group])
        end
      end

      context 'with the user status being invited' do
        let(:user_status) { :invited }

        it 'returns non locked users, groups and placeholder users that are members' do
          is_expected
            .to match_array([member_user,
                             member_placeholder_user,
                             member_group])
        end
      end

      context 'with the user status being locked' do
        let(:user_status) { :locked }

        it 'returns non locked users, groups and placeholder users that are members' do
          is_expected
            .to match_array([member_placeholder_user,
                             member_group])
        end
      end
    end

    context 'with the role not being assignable' do
      let(:role_assignable) { false }

      it 'returns nothing' do
        is_expected
          .to be_empty
      end
    end
  end
end
