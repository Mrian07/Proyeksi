

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WorkPackage, type: :model do
  describe '#backlogs_types' do
    it 'should return all the ids of types that are configures to be considered backlogs types' do
      allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'story_types' => [1], 'task_type' => 2 })

      expect(WorkPackage.backlogs_types).to match_array([1, 2])
    end

    it 'should return an empty array if nothing is defined' do
      allow(Setting).to receive(:plugin_openproject_backlogs).and_return({})

      expect(WorkPackage.backlogs_types).to eq([])
    end

    it 'should reflect changes to the configuration' do
      allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'story_types' => [1], 'task_type' => 2 })
      expect(WorkPackage.backlogs_types).to match_array([1, 2])

      allow(Setting).to receive(:plugin_openproject_backlogs).and_return({ 'story_types' => [3], 'task_type' => 4 })
      expect(WorkPackage.backlogs_types).to match_array([3, 4])
    end
  end
end
