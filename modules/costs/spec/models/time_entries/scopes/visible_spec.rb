#-- encoding: UTF-8



require 'spec_helper'

describe TimeEntries::Scopes::Visible, type: :model do
  let(:project) { FactoryBot.create(:project) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:permissions) { [:view_time_entries] }

  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      author: user2)
  end
  let(:user2) do
    FactoryBot.create(:user)
  end
  let!(:own_project_time_entry) do
    FactoryBot.create(:time_entry,
                      project: project,
                      work_package: work_package,
                      hours: 2,
                      user: user)
  end
  let!(:project_time_entry) do
    FactoryBot.create(:time_entry,
                      project: project,
                      work_package: work_package,
                      hours: 2,
                      user: user2)
  end
  let!(:own_other_project_time_entry) do
    FactoryBot.create(:time_entry,
                      project: FactoryBot.create(:project),
                      user: user)
  end

  describe '.visible' do
    subject { TimeEntry.visible(user) }

    context 'for a user having the view_time_entries permission' do
      it 'retrieves all the time entries of projects the user has the permissions in' do
        expect(subject)
          .to match_array([own_project_time_entry, project_time_entry])
      end
    end

    context 'for a user having the view_own_time_entries permission' do
      let(:permissions) { [:view_own_time_entries] }

      it 'retrieves all the time entries of the user in projects the user has the permissions in' do
        expect(subject)
          .to match_array([own_project_time_entry])
      end
    end
  end
end
