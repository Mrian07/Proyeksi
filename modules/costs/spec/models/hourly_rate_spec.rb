

require File.dirname(__FILE__) + '/../spec_helper'

describe HourlyRate, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:user) { FactoryBot.create(:user) }
  let(:rate) do
    FactoryBot.build(:hourly_rate, project: project,
                                   user: user)
  end

  describe '#user' do
    describe 'WHEN an existing user is provided' do
      before do
        rate.user = user
        rate.save!
      end

      it { expect(rate.user).to eq(user) }
    end

    describe 'WHEN a non existing user is provided (i.e. the user is deleted)' do
      before do
        rate.user = user
        rate.save!
        user.destroy
        rate.reload
      end

      it { expect(rate.user).to eq(DeletedUser.first) }
    end
  end
end
