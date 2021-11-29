#-- encoding: UTF-8


require 'spec_helper'

shared_context 'with CreateFromJournalJob context' do
  shared_let(:project) { FactoryBot.create(:project_with_types) }
  let(:permissions) { [] }
  let(:recipient) do
    FactoryBot.create(:user,
                      notification_settings: recipient_notification_settings,
                      member_in_project: project,
                      member_through_role: FactoryBot.create(:role, permissions: permissions),
                      login: recipient_login)
  end
  let(:recipient_login) { "johndoe" }
  let(:other_user) do
    notification_settings = [
      FactoryBot.build(:notification_setting, **notification_settings_all_false)
    ]

    FactoryBot.create(:user,
                      notification_settings: notification_settings)
  end
  let(:notification_settings_all_false) do
    NotificationSetting
      .all_settings
      .index_with(false)
  end

  let(:notification_settings_all_true) do
    NotificationSetting
      .all_settings
      .index_with(true)
  end

  let(:recipient_notification_settings) do
    [
      FactoryBot.build(:notification_setting, **notification_settings_all_true)
    ]
  end
  let(:send_notifications) { true }

  shared_examples_for 'creates notification' do
    let(:sender) { author }
    let(:notification_channel_reasons) do
      {
        read_ian: false,
        reason: :mentioned,
        mail_reminder_sent: false
      }
    end
    let(:notification) { FactoryBot.build_stubbed(:notification) }

    it 'creates a notification and returns it' do
      notifications_service = instance_double(Notifications::CreateService)

      allow(Notifications::CreateService)
        .to receive(:new)
              .with(user: sender)
              .and_return(notifications_service)
      allow(notifications_service)
        .to receive(:call)
              .and_return(ServiceResult.new(success: true, result: notification))

      expect(call.all_results)
        .to match_array([notification])

      expect(notifications_service)
        .to have_received(:call)
              .with({ recipient_id: recipient.id,
                      project: project,
                      actor: sender,
                      journal: journal,
                      resource: resource }.merge(notification_channel_reasons))
    end
  end

  shared_examples_for 'creates no notification' do
    it 'creates no notification' do
      allow(Notifications::CreateService)
        .to receive(:new)
              .and_call_original

      call

      expect(Notifications::CreateService)
        .not_to have_received(:new)
    end
  end
end
