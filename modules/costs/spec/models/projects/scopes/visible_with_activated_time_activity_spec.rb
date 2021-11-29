#-- encoding: UTF-8



require 'spec_helper'

describe Projects::Scopes::VisibleWithActivatedTimeActivity, type: :model do
  let!(:activity) { FactoryBot.create(:time_entry_activity) }
  let!(:project) { FactoryBot.create(:project) }
  let!(:other_project) { FactoryBot.create(:project) }
  let(:project_permissions) { [:view_time_entries] }
  let(:other_project_permissions) { [:view_time_entries] }
  let(:current_user) do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:member,
                        project: project,
                        principal: u,
                        roles: [FactoryBot.create(:role, permissions: project_permissions)])

      FactoryBot.create(:member,
                        project: other_project,
                        principal: u,
                        roles: [FactoryBot.create(:role, permissions: other_project_permissions)])
    end
  end

  before do
    login_as(current_user)
  end

  describe '.fetch' do
    subject { Project.visible_with_activated_time_activity(activity) }

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

      context 'and having only view_own_time_entries_permission' do
        let(:project_permissions) { [:view_own_time_entries] }
        let(:other_project_permissions) { [:view_own_time_entries] }

        it 'returns all projects' do
          is_expected
            .to match_array [project, other_project]
        end
      end

      context 'and having no view permission' do
        let(:project_permissions) { [] }
        let(:other_project_permissions) { [] }

        it 'returns all projects' do
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
