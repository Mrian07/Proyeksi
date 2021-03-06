

require 'spec_helper'

require 'support/shared/acts_as_watchable'

describe Message, type: :model do
  let(:message) { FactoryBot.create(:message) }

  it_behaves_like 'acts_as_watchable included' do
    let(:model_instance) { message }
    let(:watch_permission) { :view_messages } # view_messages is a public permission
    let(:project) { model_instance.forum.project }
  end

  it_behaves_like 'acts_as_attachable included' do
    let(:model_instance) { FactoryBot.create(:message) }
  end

  describe '#project' do
    it 'is the same as the project on wiki' do
      expect(message.project).to eql(message.forum.project)
    end
  end

  describe 'with forum' do
    shared_let(:forum) { FactoryBot.create :forum }
    let(:message) do
      FactoryBot.build(:message, forum: forum, subject: 'Test message', content: 'Test message content')
    end

    it 'should create' do
      topics_count = forum.topics_count
      messages_count = forum.messages_count

      expect(message.save).to be_truthy
      forum.reload
      # topics count incremented
      expect(forum.topics_count).to eq topics_count + 1
      expect(forum.messages_count).to eq messages_count + 1
      # messages count incremented
      expect(forum.last_message).to eq message

      message.reload
    end

    context 'with previous message' do
      let(:topic) { FactoryBot.create :message }
      let(:reply) do
        FactoryBot.create :message, forum: forum, subject: 'Test reply', parent: topic
      end

      it 'should reply' do
        topics_count = forum.topics_count
        messages_count = forum.messages_count
        replies_count = topic.replies_count

        expect(reply.save).to be_truthy
        forum.reload
        # same topics count
        expect(forum.topics_count).to eq topics_count
        # messages count incremented
        expect(forum.messages_count).to eq messages_count + 1
        expect(forum.last_message).to eq reply

        topic.reload
        # replies count incremented
        expect(topic.replies_count).to eq replies_count + 1
        expect(topic.last_reply).to eq reply
      end
    end

    describe 'moving' do
      let!(:forum1) { FactoryBot.create :forum }
      let!(:forum2) { FactoryBot.create :forum }
      let!(:message) { FactoryBot.create :message, forum: forum1 }

      it 'should moving message should update counters' do
        expect do
          forum1.reload
          expect(forum1.topics_count).to eq 1
          expect(forum1.messages_count).to eq 1
          expect(forum2.topics_count).to eq 0
          expect(forum2.messages_count).to eq 0

          expect(message.update(forum: forum2)).to be_truthy

          expect(forum1.reload.topics_count).to eq 0
          expect(forum2.reload.topics_count).to eq 1
          expect(forum1.messages_count).to eq 0
          expect(forum2.messages_count).to eq 1
        end.not_to change { Message.count }
      end
    end

    it 'should set sticky' do
      message = Message.new
      expect(message.sticky).to eq 0
      message.sticky = nil
      expect(message.sticky).to eq 0
      message.sticky = false
      expect(message.sticky).to eq 0
      message.sticky = true
      expect(message.sticky).to eq 1
      message.sticky = '0'
      expect(message.sticky).to eq 0
      message.sticky = '1'
      expect(message.sticky).to eq 1
    end

    describe 'with reply set' do
      let!(:reply) do
        FactoryBot.create :message, forum: message.forum, parent: message
      end

      it 'should destroy topic' do
        forum = message.forum.reload
        expect(forum.topics_count).to eq 1
        expect(forum.messages_count).to eq 2

        message.destroy
        forum.reload

        expect(forum.topics_count).to eq 0
        expect(forum.messages_count).to eq 0
      end

      it 'should destroy reply' do
        forum = message.forum
        expect(forum.topics_count).to eq 1
        expect(forum.messages_count).to eq 2

        reply.destroy
        forum.reload

        # Checks counters
        expect(forum.topics_count).to eq 1
        expect(forum.messages_count).to eq 1
      end
    end
  end
end
