#-- encoding: UTF-8


require 'spec_helper'
require_relative './create_from_journal_job_shared'

describe Notifications::CreateFromModelService, 'message', with_settings: { journal_aggregation_time_minutes: 0 } do
  subject(:call) do
    described_class.new(journal).call(send_notifications)
  end

  include_context 'with CreateFromJournalJob context'

  shared_let(:project) { FactoryBot.create(:project) }
  shared_let(:forum) { FactoryBot.create(:forum, project: project) }

  let(:permissions) { [:view_messages] }
  let(:send_notifications) { true }

  let(:resource) do
    FactoryBot.create(:message,
                      forum: forum,
                      parent: root_message)
  end
  let(:journal) { resource.journals.last }
  let(:author) { other_user }
  let(:root_message) do
    FactoryBot.create(:message,
                      forum: forum)
  end

  current_user { other_user }

  before do
    recipient
  end

  describe '#perform' do
    context 'with a newly created message' do
      context 'with the user having registered for all notifications' do
        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :subscribed,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user having registered for involved notifications' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(involved: true))
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for no notifications' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and watching the forum' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        before do
          forum.watcher_users << recipient
        end

        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :watched,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user not having registered for watcher notifications and watching the forum' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        before do
          forum.watcher_users << recipient
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and not watching the forum nor root message' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and watching the root' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        before do
          root_message.watcher_users << recipient
        end

        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :watched,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user not having registered for watcher notifications and watching the root' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        before do
          root_message.watcher_users << recipient
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for all notifications but lacking permissions' do
        before do
          recipient.members.destroy_all
        end

        it_behaves_like 'creates no notification'
      end
    end

    context 'with an updated message' do
      before do
        resource.subject = 'A new subject'
        resource.save!
      end

      context 'with the user having registered for all notifications' do
        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :subscribed,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user having registered for involved notifications' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(involved: true))
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for no notifications' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and watching the forum' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        before do
          forum.watcher_users << recipient
        end

        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :watched,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user not having registered for watcher notifications and watching the forum' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        before do
          forum.watcher_users << recipient
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and not watching the forum nor root message' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for watcher notifications and watching the root' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false.merge(watched: true))
          ]
        end

        before do
          root_message.watcher_users << recipient
        end

        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :watched,
              mail_reminder_sent: nil,
              mail_alert_sent: false
            }
          end
        end
      end

      context 'with the user not having registered for watcher notifications and watching the root' do
        let(:recipient_notification_settings) do
          [
            FactoryBot.build(:notification_setting, **notification_settings_all_false)
          ]
        end

        before do
          root_message.watcher_users << recipient
        end

        it_behaves_like 'creates no notification'
      end

      context 'with the user having registered for all notifications but lacking permissions' do
        before do
          recipient.members.destroy_all
        end

        it_behaves_like 'creates no notification'
      end
    end
  end
end
