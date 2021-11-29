#-- encoding: UTF-8



require 'spec_helper'

describe Queries::TimeEntries::Filters::ActivityFilter, type: :model do
  let(:time_entry_activity1) { FactoryBot.build_stubbed(:time_entry_activity) }
  let(:time_entry_activity2) { FactoryBot.build_stubbed(:time_entry_activity) }
  let(:activities) { [time_entry_activity1, time_entry_activity2] }
  let(:plucked_allowed_values) do
    activities.map { |x| [x.name, x.id] }
  end

  before do
    allow(::TimeEntryActivity)
      .to receive_message_chain(:shared)
      .and_return(activities)

    allow(::TimeEntryActivity)
      .to receive_message_chain(:where, :or)
      .and_return(activities)

    allow(activities)
      .to receive(:where)
      .and_return(activities)

    allow(activities)
      .to receive(:pluck)
      .with(:id)
      .and_return(activities.map(&:id))

    allow(activities)
      .to receive(:pluck)
      .with(:name, :id)
      .and_return(activities.map { |x| [x.name, x.id] })
  end

  it_behaves_like 'basic query filter' do
    let(:class_key) { :activity_id }
    let(:type) { :list_optional }
    let(:name) { TimeEntry.human_attribute_name(:activity) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expect(instance.allowed_values).to match_array(activities.map { |x| [x.name, x.id] })
      end
    end

    it_behaves_like 'list_optional query filter' do
      let(:attribute) { :activity_id }
      let(:model) { TimeEntry }
      let(:valid_values) { activities.map { |a| a.id.to_s } }
    end
  end
end
