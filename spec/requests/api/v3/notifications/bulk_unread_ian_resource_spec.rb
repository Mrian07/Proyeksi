

require 'spec_helper'

describe ::API::V3::Notifications::NotificationsAPI,
         'bulk unset read status',
         type: :request,
         content_type: :json do
  include API::V3::Utilities::PathHelper

  shared_let(:recipient) { FactoryBot.create :user }
  shared_let(:other_recipient) { FactoryBot.create :user }
  shared_let(:notification1) { FactoryBot.create :notification, recipient: recipient, read_ian: true }
  shared_let(:notification2) { FactoryBot.create :notification, recipient: recipient, read_ian: true }
  shared_let(:notification3) { FactoryBot.create :notification, recipient: recipient, read_ian: true }
  shared_let(:other_user_notification) { FactoryBot.create :notification, recipient: other_recipient, read_ian: true }

  let(:filters) { nil }

  let(:read_path) do
    api_v3_paths.path_for :notification_bulk_unread_ian, filters: filters
  end

  let(:parsed_response) { JSON.parse(last_response.body) }

  before do
    login_as current_user

    post read_path
  end

  describe 'POST /api/v3/notifications/unread_ian' do
    let(:current_user) { recipient }

    it 'returns 204' do
      expect(last_response.status)
        .to eql(204)
    end

    it 'sets all the current users`s notifications to read' do
      expect(::Notification.where(id: [notification1.id, notification2.id, notification3.id]).pluck(:read_ian))
        .to all(be_falsey)

      expect(::Notification.where(id: [other_user_notification]).pluck(:read_ian))
        .to all(be_truthy)
    end

    context 'with a filter for id' do
      let(:filters) do
        [
          {
            'id' => {
              'operator' => '=',
              'values' => [notification1.id.to_s, notification2.id.to_s]

            }
          }
        ]
      end

      it 'sets the current users`s notifications matching the filter to read' do
        expect(::Notification.where(id: [notification1.id, notification2.id]).pluck(:read_ian))
          .to all(be_falsey)

        expect(::Notification.where(id: [other_user_notification, notification3.id]).pluck(:read_ian))
          .to all(be_truthy)
      end
    end

    context 'with an invalid filter' do
      let(:filters) do
        [
          {
            'bogus' => {
              'operator' => '=',
              'values' => []

            }
          }
        ]
      end

      it 'returns 400' do
        expect(last_response.status)
          .to eql(400)
      end
    end
  end
end
