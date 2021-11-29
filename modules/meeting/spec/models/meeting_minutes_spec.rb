

require File.dirname(__FILE__) + '/../spec_helper'

describe 'MeetingMinutes', type: :model do
  before do
    @min = FactoryBot.build :meeting_minutes
  end

  # meeting minutes are editable when the meeting agenda is locked
  describe '#editable?' do
    before(:each) do
      @mee = FactoryBot.build :meeting
      @min.meeting = @mee
    end
    describe 'with no agenda present' do
      it 'is not editable' do
        expect(@min.editable?).to be_falsey
      end
    end
    describe 'with an agenda present' do
      before(:each) do
        @a = FactoryBot.build :meeting_agenda
        @mee.agenda = @a
      end
      it 'is not editable when the agenda is open' do
        expect(@min.editable?).to be_falsey
      end
      it 'is editable when the agenda is closed' do
        @a.lock!
        expect(@min.editable?).to be_truthy
      end
    end
  end
end
