#-- encoding: UTF-8



require 'spec_helper'

describe Users::Scopes::Newest, type: :model do
  describe '.newest' do
    let!(:anonymous_user) { FactoryBot.create(:anonymous) }
    let!(:system_user) { FactoryBot.create(:system) }
    let!(:deleted_user) { FactoryBot.create(:deleted_user) }
    let!(:group) { FactoryBot.create(:group) }
    let!(:user1) { FactoryBot.create(:user) }
    let!(:user2) { FactoryBot.create(:user) }
    let!(:user3) { FactoryBot.create(:user) }
    let!(:placeholder_user) { FactoryBot.create(:placeholder_user) }

    subject { User.newest }

    it 'returns only actual users ordered by creation date desc' do
      expect(subject.to_a)
        .to eql [user3, user2, user1]
    end
  end
end
