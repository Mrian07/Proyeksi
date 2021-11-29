#-- encoding: UTF-8



require 'spec_helper'

shared_examples_for 'message contract' do
  let(:current_user) do
    FactoryBot.build_stubbed(:user) do |user|
      allow(user)
        .to receive(:allowed_to?) do |permission, permission_project|
        permissions.include?(permission) && message_project == permission_project
      end
    end
  end
  let(:reply_message) { FactoryBot.build_stubbed(:message) }
  let(:other_user) { FactoryBot.build_stubbed(:user) }
  let(:message_forum) do
    FactoryBot.build_stubbed(:forum)
  end
  let(:message_project) { FactoryBot.build_stubbed(:project) }
  let(:message_parent) { FactoryBot.build_stubbed(:message) }
  let(:message_subject) { "Subject" }
  let(:message_content) { "A content" }
  let(:message_author) { other_user }
  let(:message_last_reply) { reply_message }
  let(:message_locked) { true }
  let(:message_sticky) { true }

  def expect_valid(valid, symbols = {})
    expect(contract.validate).to eq(valid)

    symbols.each do |key, arr|
      expect(contract.errors.symbols_for(key)).to match_array arr
    end
  end

  shared_examples 'is valid' do
    it 'is valid' do
      expect_valid(true)
    end
  end

  it_behaves_like 'is valid'
end
