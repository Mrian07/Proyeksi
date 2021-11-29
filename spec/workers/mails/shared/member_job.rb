

require 'spec_helper'

shared_examples 'member job' do
  subject(:run_job) do
    described_class.perform_now(current_user: current_user,
                                member: member,
                                message: message)
  end

  let(:member) do
    FactoryBot.build_stubbed(:member,
                             project: project,
                             principal: principal)
  end
  let(:project) { FactoryBot.build_stubbed(:project) }
  let(:principal) { user }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:group_users) { [user] }
  let(:group_member_roles) do
    [FactoryBot.build_stubbed(:member_role,
                              role: role,
                              inherited_from: nil)]
  end
  let(:group_user_member_roles) do
    [FactoryBot.build_stubbed(:member_role,
                              role: role,
                              inherited_from: nil)]
  end

  let(:group_user_member) do
    FactoryBot.build_stubbed(:member,
                             project: project,
                             principal: user,
                             member_roles: group_user_member_roles) do |gum|
      group_user_members << gum
    end
  end
  let(:group) do
    FactoryBot.build_stubbed(:group).tap do |g|
      scope = group_user_members

      allow(Member)
        .to receive(:of)
              .with(project)
              .and_return(scope)

      allow(scope)
        .to receive(:where)
              .with(principal: group_users)
              .and_return(scope)

      allow(scope)
        .to receive(:includes)
              .and_return(scope)

      allow(g)
        .to receive(:users)
              .and_return(group_users)
    end
  end
  let(:group_user_members) { [] }
  let(:role) { FactoryBot.build_stubbed(:role) }
  let(:member_role_inherited_from) { nil }
  let(:message) { "Some message" }

  current_user { FactoryBot.build_stubbed(:user) }

  before do
    %i[added_project updated_global updated_project].each do |mails|
      allow(MemberMailer)
        .to receive(mails)
              .and_return(double('mail', deliver_now: nil))  # rubocop:disable Rspec/VerifiedDoubles
    end
  end

  shared_examples_for 'sends no mail' do
    it 'sends no mail' do
      run_job

      %i[added_project updated_global updated_project].each do |mails|
        expect(MemberMailer)
          .not_to have_received(mails)
      end
    end
  end

  context 'with a global membership' do
    let(:project) { nil }

    context 'with sending enabled' do
      it 'sends mail' do
        run_job

        expect(MemberMailer)
          .to have_received(:updated_global)
                .with(current_user, member, message)
      end
    end

    context 'with sending disabled' do
      let(:principal) do
        FactoryBot.create :user,
                          notification_settings: [
                            FactoryBot.build(:notification_setting,
                                             NotificationSetting::MEMBERSHIP_ADDED => false,
                                             NotificationSetting::MEMBERSHIP_UPDATED => false)
                          ]
      end

      it 'still sends mail due to the message present' do
        run_job

        expect(MemberMailer)
          .to have_received(:updated_global)
                .with(current_user, member, message)
      end

      context 'when the message is nil' do
        let(:message) { '' }

        it_behaves_like 'sends no mail'
      end
    end

    context 'with the current user being the membership user' do
      let(:user) { current_user }

      it_behaves_like 'sends no mail'
    end
  end

  context 'with a user membership' do
    context 'with sending enabled' do
      it 'sends mail' do
        run_job

        expect(MemberMailer)
          .to have_received(user_project_mail_method)
                .with(current_user, member, message)
      end
    end

    context 'with the current user being the member user' do
      let(:user) { current_user }

      it_behaves_like 'sends no mail'
    end
  end
end
