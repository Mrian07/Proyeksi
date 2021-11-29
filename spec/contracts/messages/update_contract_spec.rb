#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe Messages::UpdateContract do
  it_behaves_like 'message contract' do
    let(:message) do
      FactoryBot.build_stubbed(:message).tap do |message|
        message.forum = message_forum
        message.parent = message_parent
        message.subject = message_subject
        message.content = message_content
        message.last_reply = message_last_reply
        message.locked = message_locked
        message.sticky = message_sticky
      end
    end
    subject(:contract) { described_class.new(message, current_user) }

    context 'if the author is changed' do
      it 'is invalid' do
        message.author = other_user
        expect_valid(false, author_id: %i(error_readonly))
      end
    end
  end
end
