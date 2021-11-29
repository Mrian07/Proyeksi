

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Task, type: :model do
  let(:task_type) { FactoryBot.create(:type) }
  let(:default_status) { FactoryBot.create(:default_status) }
  let(:project) { FactoryBot.create(:project) }
  let(:task) do
    FactoryBot.build(:task,
                     project: project,
                     status: default_status,
                     type: task_type)
  end

  before(:each) do
    allow(Setting)
      .to receive(:plugin_openproject_backlogs)
      .and_return({ 'task_type' => task_type.id.to_s })
  end

  describe 'copying remaining_hours to estimated_hours and vice versa' do
    context 'providing only remaining_hours' do
      before do
        task.remaining_hours = 3

        task.save!
      end

      it 'copies to estimated_hours' do
        expect(task.estimated_hours)
          .to eql task.remaining_hours
      end
    end

    context 'providing only estimated_hours' do
      before do
        task.estimated_hours = 3

        task.save!
      end

      it 'copies to estimated_hours' do
        expect(task.remaining_hours)
          .to eql task.estimated_hours
      end
    end

    context 'providing estimated_hours and remaining_hours' do
      before do
        task.estimated_hours = 3
        task.remaining_hours = 5

        task.save!
      end

      it 'leaves the values unchanged' do
        expect(task.remaining_hours)
          .to eql 5.0

        expect(task.estimated_hours)
          .to eql 3.0
      end
    end
  end
end
