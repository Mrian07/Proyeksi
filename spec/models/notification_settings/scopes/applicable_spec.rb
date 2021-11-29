

require 'spec_helper'

describe NotificationSettings::Scopes::Applicable, type: :model do
  describe '.applicable' do
    subject(:scope) { ::NotificationSetting.applicable(project) }

    let!(:user) do
      FactoryBot.create(:user,
                        notification_settings: notification_settings)
    end
    let!(:project) do
      FactoryBot.create(:project)
    end

    context 'when only global settings exist' do
      let(:notification_settings) do
        [
          FactoryBot.build(:notification_setting, project: nil)
        ]
      end

      it 'returns the global settings' do
        expect(scope)
          .to match_array(notification_settings)
      end
    end

    context 'when global and project settings exist' do
      let(:project_notification_settings) do
        [
          FactoryBot.build(:notification_setting, project: project)
        ]
      end
      let(:global_notification_settings) do
        [
          FactoryBot.build(:notification_setting)
        ]
      end
      let(:notification_settings) { project_notification_settings + global_notification_settings }

      it 'returns the project settings' do
        expect(scope)
          .to match_array(project_notification_settings)
      end
    end

    context 'when global and project settings exist but for a different project' do
      let(:other_project) { FactoryBot.create(:project) }
      let(:project_notification_settings) do
        [
          FactoryBot.build(:notification_setting, project: other_project)
        ]
      end
      let(:global_notification_settings) do
        [
          FactoryBot.build(:notification_setting)
        ]
      end
      let(:notification_settings) { project_notification_settings + global_notification_settings }

      it 'returns the project settings' do
        expect(scope)
          .to match_array(global_notification_settings)
      end
    end
  end
end
