

require 'spec_helper'
require 'rack/test'

describe 'API v3 UserPreferences resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include ::API::V3::Utilities::PathHelper

  subject(:response) { last_response }

  let(:user) { FactoryBot.create(:user, preference: preference) }
  let(:preference) do
    FactoryBot.create(:user_preference,
                      settings: {
                        daily_reminders: {
                          enabled: false,
                          times: %w[07:00:00+00:00 15:00:00+00:00]
                        }
                      })
  end
  let(:preference_path) { api_v3_paths.user_preferences(user.id) }

  current_user { user }

  describe '#GET' do
    before do
      get preference_path
    end

    context 'when not logged in' do
      let(:user) { User.anonymous }

      it 'responds with 200' do
        expect(subject.status).to eq(200)
      end

      it 'responds with a UserPreferences representer' do
        expect(subject.body).to be_json_eql('UserPreferences'.to_json).at_path('_type')
      end
    end

    context 'when logged in' do
      it 'responds with 200' do
        expect(subject.status).to eq(200)
      end

      it 'responds with a UserPreferences representer' do
        expect(subject.body).to be_json_eql('UserPreferences'.to_json).at_path('_type')
      end
    end
  end

  describe '#PATCH' do
    before do
      patch preference_path, params.to_json
      preference.reload
    end

    context 'when not logged in' do
      let(:user) { User.anonymous }
      let(:params) do
        { whatever: true }
      end

      it 'responds with 401' do
        expect(subject.status).to eq(401)
      end
    end

    context 'when updating the email_reminder settings' do
      let(:params) do
        {
          dailyReminders: {
            enabled: true,
            times: %w[08:00 18:00]
          }
        }
      end

      it 'responds with 200' do
        expect(subject.status)
          .to eq(200)
      end

      it 'updates the time zone' do
        expect(preference.daily_reminders)
          .to eql("enabled" => true, "times" => %w[08:00:00+00:00 18:00:00+00:00])
      end
    end

    context 'when attempting to update the email_reminder settings with invalid values' do
      let(:params) do
        {
          dailyReminders: {
            enabled: true,
            times: %w[invalid 18:00:00+00:00]
          }
        }
      end

      it 'responds with 422 and explains the error' do
        expect(subject.status).to eq(422)

        expect(subject.body)
          .to be_json_eql("Daily reminders does not match the expected format 'time' at path 'times/0'.".to_json)
                .at_path('_embedded/errors/0/message')

        expect(subject.body)
          .to be_json_eql("dailyReminders".to_json)
                .at_path('_embedded/errors/0/_embedded/details/attribute')

        expect(subject.body)
          .to be_json_eql("Daily reminders can only be configured to be delivered at a full hour.".to_json)
                .at_path('_embedded/errors/1/message')

        expect(subject.body)
          .to be_json_eql("dailyReminders".to_json)
                .at_path('_embedded/errors/1/_embedded/details/attribute')
      end

      it 'keeps the previous values' do
        expect(preference.daily_reminders)
          .to eql("enabled" => false, "times" => %w[07:00:00+00:00 15:00:00+00:00])
      end
    end

    context 'when updating the timezone' do
      context 'with invalid timezone' do
        let(:params) do
          { timeZone: 'Europe/Awesomeland' }
        end

        it_behaves_like 'constraint violation' do
          let(:message) { 'Time zone is not set to one of the allowed values.' }
        end
      end

      context 'with valid time zone' do
        let(:params) do
          { timeZone: 'Europe/Paris' }
        end

        it 'responds with a UserPreferences representer' do
          expect(subject.body).to be_json_eql('Europe/Paris'.to_json).at_path('timeZone')
          expect(preference.time_zone).to eq('Europe/Paris')
        end
      end
    end
  end
end
