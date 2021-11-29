#-- encoding: UTF-8



require 'spec_helper'

describe Queries::TimeEntries::Filters::UserFilter, type: :model do
  let(:user1) { FactoryBot.build_stubbed(:user) }
  let(:user2) { FactoryBot.build_stubbed(:user) }

  before do
    allow(Principal)
      .to receive_message_chain(:in_visible_project, :pluck)
      .with(:id)
      .and_return([user1.id, user2.id])
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :user_id }
    let(:type) { :list_optional }
    let(:name) { TimeEntry.human_attribute_name(:user) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expected = [[user1.id, user1.id.to_s], [user2.id, user2.id.to_s]]

        expect(instance.allowed_values).to match_array(expected)
      end
    end
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :user_id }
    let(:model) { TimeEntry }
    let(:instance_key) { :user_id }
    let(:valid_values) { [user1.id.to_s] }
  end
end
