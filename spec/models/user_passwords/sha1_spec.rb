

require 'spec_helper'

describe UserPassword::SHA1, type: :model do
  let(:legacy_password) do
    pass = FactoryBot.build(:legacy_sha1_password, plain_password: 'adminAdmin!')
    expect(pass).to receive(:salt_and_hash_password!).and_return nil

    pass.save!
    pass
  end

  describe '#matches_plaintext?' do
    it 'still matches for existing passwords' do
      expect(legacy_password).to be_a(UserPassword::SHA1)
      expect(legacy_password.matches_plaintext?('adminAdmin!')).to be_truthy
    end
  end

  describe '#create' do
    let(:legacy_password) { FactoryBot.build(:legacy_sha1_password) }

    it 'raises an exception trying to save it' do
      expect { legacy_password.save! }.to raise_error(ArgumentError)
    end
  end
end
