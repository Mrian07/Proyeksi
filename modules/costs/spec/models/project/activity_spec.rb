

require 'spec_helper'

describe Projects::Activity, type: :model do
  let(:project) do
    FactoryBot.create(:project)
  end

  let(:initial_time) { Time.now }

  let(:budget) do
    FactoryBot.create(:budget,
                      project: project)
  end

  let(:budget2) do
    FactoryBot.create(:budget,
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
    it 'is the latest budget update' do
      budget.update_attribute(:updated_at, initial_time - 10.seconds)
      budget2.update_attribute(:updated_at, initial_time - 20.seconds)
      budget.reload
      budget2.reload

      expect(latest_activity).to eql budget.updated_at
    end

    it 'takes the time stamp of the latest activity across models' do
      work_package.update_attribute(:updated_at, initial_time - 10.seconds)
      budget.update_attribute(:updated_at, initial_time - 20.seconds)

      work_package.reload
      budget.reload

      # Order:
      # work_package
      # budget

      expect(latest_activity).to eql work_package.updated_at

      work_package.update_attribute(:updated_at, budget.updated_at - 10.seconds)

      # Order:
      # budget
      # work_package

      expect(latest_activity).to eql budget.updated_at
    end
  end
end
