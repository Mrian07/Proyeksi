

require 'spec_helper'
require_relative '../support/shared/become_member'

describe Group, type: :model do
  include BecomeMember

  let(:user) { FactoryBot.build(:user) }
  let(:status) { FactoryBot.create(:status) }
  let(:role) { FactoryBot.create :role, permissions: [:view_work_packages] }

  let(:projects) do
    projects = FactoryBot.create_list :project_with_types, 20

    projects.each do |project|
      add_user_to_project! user: group, project: project, role: role
    end

    projects
  end

  let!(:work_packages) do
    projects.flat_map do |project|
      work_packages = FactoryBot.create_list(
        :work_package,
        1,
        type: project.types.first,
        author: user,
        project: project,
        status: status
      )

      work_packages.first.tap do |wp|
        wp.assigned_to = group
        wp.save!
      end
    end
  end

  let(:users) { FactoryBot.create_list :user, 100 }
  let(:group) { FactoryBot.build(:group, members: users) }

  describe '#destroy' do
    describe 'work packages assigned to the group' do
      let(:deleted_user) { DeletedUser.first }

      before do
        allow(::OpenProject::Notifications)
          .to receive(:send)

        start = Time.now.to_i

        perform_enqueued_jobs do
          Groups::DeleteService
            .new(user: User.system, contract_class: EmptyContract, model: group)
            .call
        end

        @seconds = Time.now.to_i - start

        expect(@seconds < 10).to eq true
      end

      it 'reassigns the work package to nobody and cleans up the journals' do
        expect(::OpenProject::Notifications)
          .to have_received(:send)
          .with(OpenProject::Events::MEMBER_DESTROYED, any_args)
          .exactly(projects.size).times

        work_packages.each do |wp|
          wp.reload

          expect(wp.assigned_to).to eq(deleted_user)

          wp.journals.each do |journal|
            journal.data.assigned_to_id == deleted_user.id
          end
        end
      end
    end
  end
end
