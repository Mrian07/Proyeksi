

require 'spec_helper'

describe ::Token::HashedToken, type: :model do
  let(:user) { FactoryBot.build(:user) }

  subject { described_class.new user: user }

  describe 'token value' do
    it 'is generated on a new instance' do
      expect(subject.value).to be_present
    end

    it 'provides the generated plain value on a new instance' do
      expect(subject.valid_plaintext?(subject.plain_value)).to eq true
    end

    it 'hashes the plain value to value' do
      expect(subject.value).not_to eq(subject.plain_value)
    end

    it 'does not keep the value when finding it' do
      subject.save!

      instance = described_class.where(user: user).last
      expect(instance.plain_value).to eq nil
    end
  end

  describe '#find_by_plaintext_value' do
    before do
      subject.save!
    end

    it 'finds using the plaintext value' do
      expect(described_class.find_by_plaintext_value(subject.plain_value)).to eq subject
      expect(described_class.find_by_plaintext_value('foobar')).to eq nil
    end
  end
end
