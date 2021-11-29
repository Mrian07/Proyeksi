

require 'spec_helper'
require_relative './show_resource_examples'

describe ::API::V3::PlaceholderUsers::PlaceholderUsersAPI,
         'show',
         type: :request do
  include API::V3::Utilities::PathHelper

  shared_let(:placeholder) { FactoryBot.create :placeholder_user, name: 'foo' }

  let(:send_request) do
    header "Content-Type", "application/json"
    get api_v3_paths.placeholder_user(placeholder.id)
  end

  let(:parsed_response) { JSON.parse(last_response.body) }

  current_user { user }

  before do
    send_request
  end

  describe 'admin user' do
    let(:user) { FactoryBot.build(:admin) }

    it_behaves_like 'represents the placeholder'
  end

  describe 'user with manage_placeholder_user permission' do
    let(:user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    it_behaves_like 'represents the placeholder'
  end

  describe 'user with manage_members permission' do
    let(:project) { FactoryBot.create(:project, members: { placeholder => role }) }
    let(:role) { FactoryBot.create :role, permissions: %i[manage_members]}
    let(:user) { FactoryBot.create(:user, member_in_project: project, member_through_role: role) }

    it_behaves_like 'represents the placeholder'
  end

  describe 'unauthorized user' do
    let(:user) { FactoryBot.build(:user) }

    it 'returns a 403 response' do
      expect(last_response.status).to eq(403)
    end
  end
end
