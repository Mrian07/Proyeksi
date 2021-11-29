

require 'spec_helper'

describe ::API::V3::UserPreferences::UserPreferenceRepresenter,
         'parsing' do
  subject(:parsed) { representer.from_hash request_body }

  include ::API::V3::Utilities::PathHelper

  let(:preference) { OpenStruct.new }
  let(:user) { FactoryBot.build_stubbed(:user) }
  let(:representer) { described_class.new(preference, current_user: user) }

  describe 'notification_settings' do
    let(:request_body) do
      {
        'notifications' => [
          {
            'involved' => true,
            '_links' => {
              'project' => {
                'href' => '/api/v3/projects/1'
              }
            }
          },
          {
            'involved' => false,
            'mentioned' => true,
            '_links' => {
              'project' => {
                'href' => nil
              }
            }
          }
        ]
      }
    end

    it 'parses them into an array of structs' do
      expect(subject.notification_settings).to be_a Array
      expect(subject.notification_settings.length).to eq 2
      in_project, global = subject.notification_settings

      expect(in_project[:project_id]).to eq "1"
      expect(in_project[:involved]).to be_truthy
      expect(in_project[:mentioned]).to be_nil

      expect(global[:project_id]).to eq nil
      expect(global[:involved]).to eq false
      expect(global[:mentioned]).to eq true
    end
  end

  describe 'daily_reminders' do
    let(:request_body) do
      {
        "dailyReminders" => {
          "enabled" => true,
          "times" => %w[07:00 15:00 18:00:00+00:00]
        }
      }
    end

    it 'parses the times into full iso8601 time format' do
      expect(parsed.daily_reminders)
        .to eql({
                  "enabled" => true,
                  "times" => %w[07:00:00+00:00 15:00:00+00:00 18:00:00+00:00]
                })
    end
  end

  describe 'pause_reminders' do
    let(:request_body) do
      {
        "pauseReminders" => {
          "enabled" => true,
          "firstDay" => first_day,
          "lastDay" => last_day
        }
      }
    end

    context 'with all set' do
      let(:first_day) { '2021-10-10' }
      let(:last_day) { '2021-10-20' }

      it 'sets both dates' do
        expect(parsed.pause_reminders)
          .to eql({
                    "enabled" => true,
                    "first_day" => first_day,
                    "last_day" => last_day
                  })
      end
    end

    context 'with first only set' do
      let(:first_day) { '2021-10-10' }
      let(:last_day) { nil }

      it 'uses the first day for the last day' do
        expect(parsed.pause_reminders)
          .to eql({
                    "enabled" => true,
                    "first_day" => first_day,
                    "last_day" => first_day
                  })
      end
    end

    context 'with last only set' do
      let(:first_day) { nil }
      let(:last_day) { '2021-10-10' }

      it 'uses the first day for the last day' do
        expect(parsed.pause_reminders)
          .to eql({
                    "enabled" => true,
                    "first_day" => nil,
                    "last_day" => last_day
                  })
      end
    end
  end
end
