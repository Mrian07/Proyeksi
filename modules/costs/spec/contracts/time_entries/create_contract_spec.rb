#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe TimeEntries::CreateContract do
  it_behaves_like 'time entry contract' do
    subject(:contract) do
      described_class.new(time_entry, current_user)
    end

    let(:time_entry) do
      TimeEntry.new(project: time_entry_project,
                    work_package: time_entry_work_package,
                    user: time_entry_user,
                    activity: time_entry_activity,
                    spent_on: time_entry_spent_on,
                    hours: time_entry_hours,
                    comments: time_entry_comments).tap do |t|
        t.extend(ProyeksiApp::ChangedBySystem)
        t.changed_by_system(changed_by_system) if changed_by_system
      end
    end
    let(:permissions) { %i(log_time) }
    let(:other_user) { FactoryBot.build_stubbed(:user) }
    let(:changed_by_system) do
      if time_entry_user
        { "user_id" => [nil, time_entry_user.id] }
      else
        {}
      end
    end

    context 'if user is not allowed to log time' do
      let(:permissions) { [] }

      it 'is invalid' do
        expect_valid(false, base: %i(error_unauthorized))
      end
    end

    context 'if time_entry user is not contract user' do
      let(:time_entry_user) { other_user }

      it 'is invalid' do
        expect_valid(false, user_id: %i(not_current_user))
      end
    end

    context 'if time_entry user was not set by system' do
      let(:time_entry_user) { other_user }
      let(:changed_by_system) { {} }

      it 'is invalid' do
        expect_valid(false, user_id: %i(not_current_user error_readonly))
      end
    end

    context 'if the user is nil' do
      let(:time_entry_user) { nil }

      it 'is invalid' do
        expect_valid(false, user_id: %i(blank not_current_user))
      end
    end
  end
end
