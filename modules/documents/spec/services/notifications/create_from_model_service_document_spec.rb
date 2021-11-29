#-- encoding: UTF-8


require 'spec_helper'
require Rails.root.join('spec/services/notifications/create_from_journal_job_shared')

describe Notifications::CreateFromModelService, 'document', with_settings: { journal_aggregation_time_minutes: 0 } do
  subject(:call) do
    described_class.new(journal).call(send_notifications)
  end

  include_context 'with CreateFromJournalJob context'

  shared_let(:project) { FactoryBot.create(:project) }

  let(:permissions) { [:view_documents] }
  let(:send_notifications) { true }

  let(:resource) do
    FactoryBot.create(:document,
                      project: project)
  end
  let(:journal) { resource.journals.last }
  let(:author) { other_user }

  current_user { other_user }

  before do
    recipient
  end

  describe '#perform' do
    context 'with a newly created document' do
      context 'with the user having registered for all notifications' do
        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :subscribed,
              mail_alert_sent: false,
              mail_reminder_sent: nil
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

      context 'with the user having registered for all notifications but lacking permissions' do
        before do
          recipient.members.destroy_all
        end

        it_behaves_like 'creates no notification'
      end
    end

    context 'with an updated document' do
      before do
        resource.title = 'A new subject'
        resource.save!
      end

      context 'with the user having registered for all notifications' do
        it_behaves_like 'creates notification' do
          let(:notification_channel_reasons) do
            {
              read_ian: nil,
              reason: :subscribed,
              mail_alert_sent: false,
              mail_reminder_sent: nil
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

      context 'with the user having registered for all notifications but lacking permissions' do
        before do
          recipient.members.destroy_all
        end

        it_behaves_like 'creates no notification'
      end
    end
  end
end
