#-- encoding: UTF-8



require 'spec_helper'

describe Members::Scopes::NotLocked, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role) }

  let!(:invited_user_member) do
    FactoryBot.create(:member,
                      project: project,
                      roles: [role],
                      principal: FactoryBot.create(:user, status: Principal.statuses[:invited]))
  end
  let!(:registered_user_member) do
    FactoryBot.create(:member,
                      project: project,
                      roles: [role],
                      principal: FactoryBot.create(:user, status: Principal.statuses[:registered]))
  end
  let!(:locked_user_member) do
    FactoryBot.create(:member,
                      project: project,
                      roles: [role],
                      principal: FactoryBot.create(:user, status: Principal.statuses[:locked]))
  end
  let!(:active_user_member) do
    FactoryBot.create(:member,
                      project: project,
                      roles: [role],
                      principal: FactoryBot.create(:user, status: Principal.statuses[:active]))
  end
  let!(:group_member) do
    FactoryBot.create(:member,
                      project: project,
                      roles: [role],
                      principal: FactoryBot.create(:group))
  end

  describe '.fetch' do
    subject { Member.not_locked }

    it 'returns only actual users and groups' do
      expect(subject)
        .to match_array [active_user_member,
                         invited_user_member,
                         registered_user_member,
                         group_member]
    end
  end
end
