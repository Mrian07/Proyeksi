

require 'spec_helper'

describe ::Token::Base, type: :model do
  let(:user) { FactoryBot.build(:user) }

  subject { described_class.new user: user }

  it 'should create' do
    subject.save!
    assert_equal 64, subject.value.length
  end

  it 'should create_should_remove_existing_tokens' do
    subject.save!
    t2 = Token::AutoLogin.create user: user
    expect(subject.value).not_to eq(t2.value)
    expect(Token::AutoLogin.exists?(subject.id)).to eq false
    expect(Token::AutoLogin.exists?(t2.id)).to eq true
  end
end
