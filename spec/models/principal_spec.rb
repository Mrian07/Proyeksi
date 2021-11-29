

require 'spec_helper'

describe Principal, type: :model do
  let(:user) { FactoryBot.build(:user) }
  let(:group) { FactoryBot.build(:group) }

  def self.should_return_groups_and_users_if_active(method, *params)
    it 'should return a user' do
      user.save!

      expect(Principal.send(method, *params).where(id: user.id)).to eq([user])
    end

    it 'should return a group' do
      group.save!

      expect(Principal.send(method, *params).where(id: group.id)).to eq([group])
    end

    it 'should not return the anonymous user' do
      User.anonymous

      expect(Principal.send(method, *params).where(id: user.id)).to eq([])
    end

    it 'should not return an inactive user' do
      user.status = User.statuses[:locked]

      user.save!

      expect(Principal.send(method, *params).where(id: user.id).to_a).to eq([])
    end
  end

  describe 'active' do
    should_return_groups_and_users_if_active(:active)

    it 'should not return a registered user' do
      user.status = User.statuses[:registered]

      user.save!

      expect(Principal.active.where(id: user.id)).to eq([])
    end
  end

  describe 'not_locked' do
    should_return_groups_and_users_if_active(:not_locked)

    it 'should return a registered user' do
      user.status = User.statuses[:registered]

      user.save!

      expect(Principal.not_locked.where(id: user.id)).to eq([user])
    end
  end
end
