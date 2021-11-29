

require 'spec_helper'
require_relative 'shared/member_job'

describe Mails::MemberCreatedJob, type: :model do
  include_examples 'member job' do
    let(:user_project_mail_method) { :added_project }

    context 'with a group membership' do
      let(:member) do
        FactoryBot.build_stubbed(:member,
                                 project: project,
                                 principal: group,
                                 member_roles: group_member_roles)
      end

      before do
        group_user_member
      end

      context 'with the user not having had a membership before the group`s membership was added' do
        let(:group_user_member_roles) do
          [FactoryBot.build_stubbed(:member_role,
                                    role: role,
                                    inherited_from: group_member_roles.first.id)]
        end

        it 'sends mail' do
          run_job

          expect(MemberMailer)
            .to have_received(:added_project)
                  .with(current_user, group_user_member, message)
        end
      end

      context 'with the user having had a membership with the same roles before the group`s membership was added' do
        let(:group_user_member_roles) do
          [FactoryBot.build_stubbed(:member_role,
                                    role: role,
                                    inherited_from: nil)]
        end

        it_behaves_like 'sends no mail'
      end

      context 'with the user having had a membership with the same roles
               from another group before the group`s membership was added' do
        let(:group_user_member_roles) do
          [FactoryBot.build_stubbed(:member_role,
                                    role: role,
                                    inherited_from: group_member_roles.first.id + 5)]
        end

        it_behaves_like 'sends no mail'
      end

      context 'with the user having had a membership before the group`s membership was added but now has additional roles' do
        let(:other_role) { FactoryBot.build_stubbed(:role) }
        let(:group_user_member_roles) do
          [FactoryBot.build_stubbed(:member_role,
                                    role: role,
                                    inherited_from: group_member_roles.first.id),
           FactoryBot.build_stubbed(:member_role,
                                    role: other_role,
                                    inherited_from: nil)]
        end

        it 'sends mail' do
          run_job

          expect(MemberMailer)
            .to have_received(:updated_project)
                  .with(current_user, group_user_member, message)
        end
      end
    end
  end
end
