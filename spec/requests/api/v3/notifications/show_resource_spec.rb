

require 'spec_helper'
require_relative './show_resource_examples'

describe ::API::V3::Notifications::NotificationsAPI,
         'show',
         content_type: :json,
         type: :request do
  include API::V3::Utilities::PathHelper

  shared_let(:recipient) do
    FactoryBot.create :user
  end
  shared_let(:role) { FactoryBot.create(:role, permissions: %i(view_work_packages)) }
  shared_let(:project) do
    FactoryBot.create :project,
                      members: { recipient => role }
  end
  shared_let(:resource) { FactoryBot.create :work_package, project: project }
  shared_let(:notification) do
    FactoryBot.create :notification,
                      recipient: recipient,
                      project: project,
                      resource: resource,
                      journal: resource.journals.last
  end

  let(:send_request) do
    get api_v3_paths.notification(notification.id)
  end

  before do
    login_as current_user
    send_request
  end

  describe 'recipient user' do
    let(:current_user) { recipient }

    it_behaves_like 'represents the notification'
  end

  describe 'admin user' do
    let(:current_user) { FactoryBot.build(:admin) }

    it 'returns a 404 response' do
      expect(last_response.status).to eq(404)
    end
  end

  describe 'unauthorized user' do
    let(:current_user) { FactoryBot.build(:user) }

    it 'returns a 404 response' do
      expect(last_response.status).to eq(404)
    end
  end
end
