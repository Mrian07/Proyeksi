#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_contract_examples'

describe TimeEntries::UpdateContract do
  it_behaves_like 'time entry contract' do
    let(:time_entry) do
      FactoryBot.build_stubbed(:time_entry,
                               project: time_entry_project,
                               work_package: time_entry_work_package,
                               user: time_entry_user,
                               activity: time_entry_activity,
                               spent_on: time_entry_spent_on,
                               hours: time_entry_hours,
                               comments: time_entry_comments)
    end
    subject(:contract) { described_class.new(time_entry, current_user) }
    let(:permissions) { %i(edit_time_entries) }

    context 'if user is not allowed to edit time entries' do
      let(:permissions) { [] }

      it 'is invalid' do
        expect_valid(false, base: %i(error_unauthorized))
      end
    end

    context 'if project changed' do
      let(:new_project) do
        FactoryBot.build_stubbed(:project).tap do |p|
          allow(TimeEntryActivity)
            .to receive(:active_in_project)
            .with(p)
            .and_return(activities_scope)

          allow(time_entry)
            .to receive(:project) do
            case time_entry.project_id
            when p.id
              p
            when time_entry_project.id
              time_entry_project
            end
          end

          time_entry_work_package.project = p

          allow(current_user)
            .to receive(:allowed_to?) do |permission, permission_project|
            new_project_permissions.include?(permission) && p == permission_project ||
              permissions.include?(permission) && time_entry_project == permission_project
          end
        end
      end

      before do
        time_entry.project = new_project
      end

      context 'if user is not allowed to edit time entries in old project but in new' do
        let(:permissions) { [] }
        let(:new_project_permissions) { %i(edit_time_entries) }

        it 'is invalid' do
          expect_valid(false, base: %i(error_unauthorized))
        end
      end

      context 'if user is allowed to edit time entries in old project but not in new' do
        let(:new_project_permissions) { [] }

        it 'is invalid' do
          expect_valid(false, base: %i(error_unauthorized))
        end
      end

      context 'if user is allowed to edit time entries in both projects' do
        let(:new_project_permissions) { %i(edit_time_entries) }

        it 'is valid' do
          expect_valid(true)
        end
      end
    end

    context 'if the user is nil' do
      let(:time_entry_user) { nil }

      it 'is invalid' do
        expect_valid(false, user_id: %i(blank))
      end
    end

    context 'if the user is changed' do
      it 'is invalid' do
        time_entry.user = other_user
        expect_valid(false, user_id: %i(error_readonly))
      end
    end

    context 'if time_entry user is not contract user' do
      let(:time_entry_user) { other_user }

      context 'if has permission' do
        let(:permissions) { %i[edit_time_entries] }

        it 'is valid' do
          expect_valid(true)
        end
      end

      context 'if has no permission' do
        let(:permissions) { %i[edit_own_time_entries] }
        it 'is invalid' do
          expect_valid(false, base: %i(error_unauthorized))
        end
      end
    end
  end
end
