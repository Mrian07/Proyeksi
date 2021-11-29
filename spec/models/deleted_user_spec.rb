

require 'spec_helper'

describe DeletedUser, type: :model do
  let(:user) { DeletedUser.new }

  describe '#admin' do
    it { expect(user.admin).to be_falsey }
  end

  describe '#logged?' do
    it { expect(user).not_to be_logged }
  end

  describe '#name' do
    it { expect(user.name).to eq(I18n.t('user.deleted')) }
  end

  describe '#mail' do
    it { expect(user.mail).to be_nil }
  end

  describe '#time_zone' do
    it { expect(user.time_zone).to be_nil }
  end

  describe '#rss_key' do
    it { expect(user.rss_key).to be_nil }
  end

  describe '#destroy' do
    it { expect(user.destroy).to be_falsey }
  end

  describe '#available_custom_fields' do
    before do
      FactoryBot.create(:user_custom_field)
    end

    it { expect(user.available_custom_fields).to eq([]) }
  end

  describe '#create' do
    describe 'WHEN creating a second deleted user' do
      let(:u1) { FactoryBot.build(:deleted_user) }
      let(:u2) { FactoryBot.build(:deleted_user) }

      before do
        u1.save!
        u2.save
      end

      it { expect(u1).not_to be_new_record }
      it { expect(u2).to be_new_record }
      it { expect(u2.errors[:base]).to include 'A DeletedUser already exists.' }
    end
  end

  describe '#valid' do
    describe 'WHEN no login, first-, lastname and mail is provided' do
      let(:user) { DeletedUser.new }

      it { expect(user).to be_valid }
    end
  end

  describe '#first' do
    describe 'WHEN a deleted user already exists' do
      let(:user) { FactoryBot.build(:deleted_user) }

      before do
        user.save!
      end

      it { expect(DeletedUser.first).to eq(user) }
    end

    describe 'WHEN no deleted user exists' do
      it { expect(DeletedUser.first.is_a?(DeletedUser)).to be_truthy }
      it { expect(DeletedUser.first).not_to be_new_record }
    end
  end
end
