#-- encoding: UTF-8



require 'spec_helper'

describe TimeEntryActivities::Scopes::ActiveInProject, type: :model do
  let!(:activity) { FactoryBot.create(:time_entry_activity) }
  let!(:other_activity) { FactoryBot.create(:time_entry_activity) }
  let(:project) { FactoryBot.create(:project) }
  let(:other_project) { FactoryBot.create(:project) }

  describe '.active_in_project' do
    subject { TimeEntryActivity.active_in_project(project) }

    context 'without a project configuration' do
      context 'with the activity being active' do
        it 'includes the activity' do
          is_expected
            .to match_array [activity, other_activity]
        end
      end

      context 'with the activity being inactive' do
        before do
          activity.update_attribute(:active, false)
        end

        it 'excludes the activity' do
          is_expected
            .to match_array([other_activity])
        end
      end
    end

    context 'with a project configuration configured to true' do
      before do
        activity.time_entry_activities_projects.create(project: project, active: true)
      end

      it 'includes the activity' do
        is_expected
          .to match_array [activity, other_activity]
      end

      context 'with the activity being inactive' do
        before do
          activity.update_attribute(:active, false)
        end

        it 'includes the activity' do
          is_expected
            .to match_array [activity, other_activity]
        end
      end
    end

    context 'with a project configuration configured to false but for a different project' do
      before do
        activity.time_entry_activities_projects.create(project: other_project, active: false)
      end

      it 'includes the activity' do
        is_expected
          .to match_array [activity, other_activity]
      end
    end

    context 'with a project configuration configured to false' do
      before do
        activity.time_entry_activities_projects.create(project: project, active: false)
      end

      it 'excludes the activity' do
        is_expected
          .to match_array [other_activity]
      end

      context 'with a project configuration configured to true but for a different project' do
        before do
          activity.time_entry_activities_projects.create(project: other_project, active: true)
        end

        it 'excludes the activity' do
          is_expected
            .to match_array [other_activity]
        end
      end
    end
  end
end
