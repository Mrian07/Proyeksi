

require 'spec_helper'

require 'support/shared/acts_as_watchable'

describe Forum, type: :model do
  it_behaves_like 'acts_as_watchable included' do
    let(:model_instance) { FactoryBot.create(:forum) }
    let(:watch_permission) { :view_messages } # view_messages is a public permission
    let(:project) { model_instance.project }
  end

  describe 'with forum present' do
    let(:forum) { FactoryBot.build :forum, name: 'Test forum', description: 'Whatever' }

    it 'should create' do
      expect(forum.save).to be_truthy
      forum.reload
      expect(forum.name).to eq 'Test forum'
      expect(forum.description).to eq 'Whatever'
      expect(forum.topics_count).to eq 0
      expect(forum.messages_count).to eq 0
      expect(forum.last_message).to be nil
    end
  end
end
