#-- encoding: UTF-8



require 'spec_helper'

describe TimeEntries::Scopes::OfUserAndDay, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:spent_on) { Date.today }
  let!(:time_entry) do
    FactoryBot.create(:time_entry,
                      user: user,
                      spent_on: spent_on)
  end
  let!(:other_time_entry) do
    FactoryBot.create(:time_entry,
                      user: user,
                      spent_on: spent_on)
  end
  let!(:other_user_time_entry) do
    FactoryBot.create(:time_entry,
                      user: FactoryBot.create(:user),
                      spent_on: spent_on)
  end
  let!(:other_date_time_entry) do
    FactoryBot.create(:time_entry,
                      user: user,
                      spent_on: spent_on - 3.days)
  end

  describe '.of_user_and_day' do
    subject { TimeEntry.of_user_and_day(user, spent_on) }

    it 'are all the time entries of the user on the date' do
      is_expected
        .to match_array([time_entry, other_time_entry])
    end

    context 'if excluding a time entry' do
      subject { TimeEntry.of_user_and_day(user, spent_on, excluding: other_time_entry) }

      it 'does not include the time entry' do
        is_expected
          .to match_array([time_entry])
      end
    end
  end
end
