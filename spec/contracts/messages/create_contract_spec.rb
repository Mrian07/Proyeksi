#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe Messages::CreateContract do
  it_behaves_like 'message contract' do
    let(:message) do
      Message.new(forum: message_forum,
                  parent: message_parent,
                  subject: message_subject,
                  content: message_content,
                  author: message_author,
                  last_reply: message_last_reply,
                  locked: message_locked,
                  sticky: message_sticky).tap do |m|
        m.extend(OpenProject::ChangedBySystem)
        m.changed_by_system("author_id" => [nil, message_author.id])
      end
    end

    subject(:contract) do
      described_class.new(message, current_user)
    end
  end
end
