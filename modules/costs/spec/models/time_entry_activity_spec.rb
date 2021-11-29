#-- encoding: UTF-8



require 'spec_helper'

describe TimeEntryActivity, type: :model do
  let(:new_activity) { described_class.new }
  let(:saved_activity) { described_class.create name: 'Design' }

  it 'is an enumeration' do
    expect(new_activity)
      .to be_a(Enumeration)
  end

  describe '#objects_count' do
    it 'represents the count of time entries of that activity' do
      expect { FactoryBot.create(:time_entry, activity: saved_activity) }
        .to change(saved_activity, :objects_count)
              .from(0)
              .to(1)
    end
  end

  describe '#option_name' do
    it 'is enumeration_activities' do
      expect(new_activity.option_name)
        .to eq :enumeration_activities
    end
  end
end
