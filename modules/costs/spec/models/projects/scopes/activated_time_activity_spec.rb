#-- encoding: UTF-8



require 'spec_helper'

describe Projects::Scopes::ActivatedTimeActivity, type: :model do
  let!(:activity) { FactoryBot.create(:time_entry_activity) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:other_project) { FactoryBot.create(:project) }

  describe '.activated_time_activity' do
    subject { Project.activated_time_activity(activity) }

    context 'without project specific overrides' do
      context 'and being active' do
        it 'returns all projects' do
          is_expected
            .to match_array [project, other_project]
        end
      end

      context 'and not being active' do
        before do
          activity.update_attribute(:active, false)
        end

        it 'returns no projects' do
          is_expected
            .to be_empty
        end
      end
    end

    context 'with project specific overrides' do
      before do
        TimeEntryActivitiesProject.insert({ activity_id: activity.id, project_id: project.id, active: true })
        TimeEntryActivitiesProject.insert({ activity_id: activity.id, project_id: other_project.id, active: false })
      end

      context 'and being active' do
        it 'returns the project the activity is activated in' do
          is_expected
            .to match_array [project]
        end
      end

      context 'and not being active' do
        before do
          activity.update_attribute(:active, false)
        end

        it 'returns only the projects the activity is activated in' do
          is_expected
            .to match_array [project]
        end
      end
    end
  end
end
