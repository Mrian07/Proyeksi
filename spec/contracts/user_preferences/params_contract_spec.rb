#-- encoding: UTF-8



require 'spec_helper'
require 'contracts/shared/model_contract_shared_context'

describe UserPreferences::ParamsContract do
  include_context 'ModelContract shared context'

  let(:current_user) { FactoryBot.build_stubbed(:user) }
  let(:preference_user) { current_user }
  let(:user_preference) do
    FactoryBot.build_stubbed(:user_preference,
                             user: preference_user)
  end
  let(:params) do
    {
      hide_mail: true,
      auto_hide_popups: true,
      comments_sorting: 'desc',
      daily_reminders: {
        enabled: true,
        times: %w[08:00:00+00:00 12:00:00+00:00]
      },
      time_zone: 'Brasilia',
      warn_on_leaving_unsaved: true,
      notification_settings: notification_settings
    }
  end
  let(:contract) { described_class.new(user_preference, current_user, params: params) }

  describe 'notification settings' do
    context 'when multiple global settings' do
      let(:notification_settings) do
        [
          { project_id: nil, mentioned: true },
          { project_id: nil, mentioned: true }
        ]
      end

      it_behaves_like 'contract is invalid', notification_settings: :only_one_global_setting
    end

    context 'when project settings with an email alert set' do
      let(:notification_settings) do
        [
          { project_id: 1234, news_added: true }
        ]
      end

      it_behaves_like 'contract is invalid', notification_settings: :email_alerts_global
    end

    context 'when global settings with an email alert set' do
      let(:notification_settings) do
        [
          { project_id: nil, news_added: true }
        ]
      end

      it_behaves_like 'contract is valid'
    end

    context 'when notification_settings empty' do
      let(:params) do
        {
          hide_mail: true,
          auto_hide_popups: true,
          comments_sorting: 'desc',
          daily_reminders: {
            enabled: true,
            times: %w[08:00:00+00:00 12:00:00+00:00]
          },
          time_zone: 'Brasilia',
          warn_on_leaving_unsaved: true
        }
      end

      it_behaves_like 'contract is valid'
    end
  end
end
