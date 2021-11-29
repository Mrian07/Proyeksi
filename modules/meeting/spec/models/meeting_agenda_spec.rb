

require File.dirname(__FILE__) + '/../spec_helper'

describe 'MeetingAgenda', type: :model do
  before(:each) do
    @a = FactoryBot.build :meeting_agenda, text: "Some content...\n\nMore content!\n\nExtraordinary content!!"
  end

  # TODO: Test the right user and messages are set in the history
  describe '#lock!' do
    it 'locks the agenda' do
      @a.save
      @a.reload
      @a.lock!
      @a.reload
      expect(@a.locked).to be_truthy
    end
  end

  describe '#unlock!' do
    it 'unlocks the agenda' do
      @a.locked = true
      @a.save
      @a.reload
      @a.unlock!
      @a.reload
      expect(@a.locked).to be_falsey
    end
  end

  # a meeting agenda is editable when it is not locked
  describe '#editable?' do
    it 'is editable when not locked' do
      @a.locked = false
      expect(@a.editable?).to be_truthy
    end
    it 'is not editable when locked' do
      @a.locked = true
      expect(@a.editable?).to be_falsey
    end
  end
end
