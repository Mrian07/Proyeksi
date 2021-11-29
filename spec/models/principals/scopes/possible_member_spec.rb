#-- encoding: UTF-8



require 'spec_helper'

describe Principals::Scopes::PossibleMember, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role) }
  let!(:active_user) { FactoryBot.create(:user) }
  let!(:locked_user) { FactoryBot.create(:user, status: :locked) }
  let!(:registered_user) { FactoryBot.create(:user, status: :registered) }
  let!(:invited_user) { FactoryBot.create(:user, status: :invited) }
  let!(:anonymous_user) { FactoryBot.create(:anonymous) }
  let!(:placeholder_user) { FactoryBot.create(:placeholder_user) }
  let!(:group) { FactoryBot.create(:group) }
  let!(:member_user) do
    FactoryBot.create(:user,
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

  describe '.possible_member' do
    subject { Principal.possible_member(project) }

    it 'returns non locked users, groups and placeholder users not part of the project yet' do
      is_expected
        .to match_array([active_user,
                         registered_user,
                         invited_user,
                         placeholder_user,
                         group])
    end
  end
end
