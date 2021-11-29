

require 'spec_helper'

describe Projects::Activity, type: :model do
  let(:project) do
    FactoryBot.create(:project)
  end

  let(:initial_time) { Time.now }

  let(:meeting) do
    FactoryBot.create(:meeting,
                      project: project)
  end

  let(:meeting2) do
    FactoryBot.create(:meeting,
                      project: project)
  end

  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project)
  end

  def latest_activity
    Project.with_latest_activity.find(project.id).latest_activity_at
  end

  describe '.with_latest_activity' do
    it 'is the latest meeting update' do
      meeting.update_attribute(:updated_at, initial_time - 10.seconds)
      meeting2.update_attribute(:updated_at, initial_time - 20.seconds)
      meeting.reload
      meeting2.reload

      expect(latest_activity).to eql meeting.updated_at
    end

    it 'takes the time stamp of the latest activity across models' do
      work_package.update_attribute(:updated_at, initial_time - 10.seconds)
      meeting.update_attribute(:updated_at, initial_time - 20.seconds)

      work_package.reload
      meeting.reload

      # Order:
      # work_package
      # meeting

      expect(latest_activity).to eql work_package.updated_at

      work_package.update_attribute(:updated_at, meeting.updated_at - 10.seconds)

      # Order:
      # meeting
      # work_package

      expect(latest_activity).to eql meeting.updated_at
    end
  end
end
