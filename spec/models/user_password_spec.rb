

require 'spec_helper'

describe UserPassword, type: :model do
  let(:old_password) { FactoryBot.create(:old_user_password) }
  let(:user) { FactoryBot.create(:user) }
  let(:password) { FactoryBot.create(:user_password, user: user, plain_password: 'adminAdmin!') }

  describe '#expired?' do
    context 'with expiry value set',
            with_settings: { password_days_valid: 30 } do
      it 'should be true for an old password when password expiry is activated' do
        expect(old_password.expired?).to be_truthy
      end

      it 'should be false when password expiry is enabled and the password was changed recently' do
        expect(password.expired?).to be_falsey
      end
    end

    context 'with expiry value disabled',
            with_settings: { password_days_valid: 0 } do
      it 'should be false for an old password when password expiry is disabled' do
        expect(old_password.expired?).to be_falsey
      end
    end
  end

  describe '#matches_plaintext?' do
    it 'still matches the password' do
      expect(password).to be_a(UserPassword.active_type)
      expect(password.matches_plaintext?('adminAdmin!')).to be_truthy
    end
  end

  describe '#rehash_as_active' do
    let(:password) do
      pass = FactoryBot.build(:legacy_sha1_password, user: user, plain_password: 'adminAdmin!')
      expect(pass).to receive(:salt_and_hash_password!).and_return nil

      pass.save!
      pass
    end

    before do
      password
      user.reload
    end

    it 'rehashed the password when correct' do
      expect(user.current_password).to be_a(UserPassword::SHA1)
      expect do
        password.matches_plaintext?('adminAdmin!')
      end.to_not change { user.passwords.count }

      expect(user.current_password).to be_a(UserPassword::Bcrypt)
      expect(user.current_password.hashed_password).to start_with '$2a$'
    end

    it 'does not alter the password when invalid' do
      expect(password.matches_plaintext?('wat')).to be false
      expect(password).to be_a(UserPassword::SHA1)
    end

    it 'does not alter the password when disabled' do
      expect(password.matches_plaintext?('adminAdmin!', update_legacy: false)).to be true
      expect(user.current_password).to be_a(UserPassword::SHA1)
    end
  end

  describe '#save' do
    let(:password) { FactoryBot.build(:user_password) }

    it 'saves correctly' do
      expect(password).to receive(:salt_and_hash_password!).and_call_original
      expect { password.save! }.not_to raise_error
      expect(password).not_to be_expired
    end
  end
end
