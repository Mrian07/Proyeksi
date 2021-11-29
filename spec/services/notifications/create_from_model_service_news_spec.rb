#-- encoding: UTF-8


require 'spec_helper'
require_relative './create_from_journal_job_shared'

describe Notifications::CreateFromModelService, 'news', with_settings: { journal_aggregation_time_minutes: 0 } do
  subject(:call) do
    described_class.new(journal).call(send_notifications)
  end

  include_context 'with CreateFromJournalJob context'

  let(:journable) { FactoryBot.build_stubbed(:news) }

  let(:resource) { FactoryBot.create(:news, project: project) }

  # view_news is a public permission
  let(:permissions) { [] }
  let(:send_notifications) { true }
  let(:journal) { resource.journals.last }
  let(:author) { other_user }

  current_user { other_user }

  before do
    recipient
  end

  describe '#call' do
    context 'with a newly created news do' do
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
    end

    context 'with an updated news' do
      before do
        resource.description = "Some new text to create a journal"
        resource.save!
      end

      context 'with the user having registered for all notifications' do
        it_behaves_like 'creates no notification'
      end
    end
  end
end
