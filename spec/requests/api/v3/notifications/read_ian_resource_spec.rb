

require 'spec_helper'

describe ::API::V3::Notifications::NotificationsAPI,
         'update read status',
         type: :request,
         content_type: :json do
  include API::V3::Utilities::PathHelper

  shared_let(:project) { FactoryBot.create(:project) }
  shared_let(:work_package) { FactoryBot.create(:work_package, project: project) }
  shared_let(:recipient) do
    FactoryBot.create :user,
                      member_in_project: project,
                      member_with_permissions: %i[view_work_packages]
  end
  shared_let(:notification) do
    FactoryBot.create :notification,
                      recipient: recipient,
                      resource: work_package,
                      project: project
  end

  let(:send_read) do
    post api_v3_paths.notification_read_ian(notification.id)
  end

  let(:send_unread) do
    post api_v3_paths.notification_unread_ian(notification.id)
  end

  let(:parsed_response) { JSON.parse(last_response.body) }

  before do
    login_as current_user
  end

  describe 'recipient user' do
    let(:current_user) { recipient }

    it 'can read and unread' do
      send_read
      expect(last_response.status).to eq(204)
      expect(notification.reload.read_ian).to be_truthy

      send_unread
      expect(last_response.status).to eq(204)
      expect(notification.reload.read_ian).to be_falsey
    end
  end

  describe 'admin user' do
    let(:current_user) { FactoryBot.build(:admin) }

    it 'returns a 404 response' do
      send_read
      expect(last_response.status).to eq(404)

      send_unread
      expect(last_response.status).to eq(404)
    end
  end
end
