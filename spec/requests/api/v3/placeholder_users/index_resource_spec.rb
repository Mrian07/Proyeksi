

require 'spec_helper'
require 'rack/test'

describe ::API::V3::PlaceholderUsers::PlaceholderUsersAPI,
         'index',
         type: :request do

  include API::V3::Utilities::PathHelper

  shared_let(:placeholder1) { FactoryBot.create :placeholder_user, name: 'foo' }
  shared_let(:placeholder2) { FactoryBot.create :placeholder_user, name: 'bar' }

  let(:send_request) do
    header "Content-Type", "application/json"
    get api_v3_paths.placeholder_users
  end

  let(:parsed_response) { JSON.parse(last_response.body) }

  current_user { user }

  before do
    send_request
  end

  describe 'admin user' do
    let(:user) { FactoryBot.build(:admin) }

    it_behaves_like 'API V3 collection response', 2, 2, 'PlaceholderUser'
  end

  describe 'user with manage_placeholder_user permission' do
    let(:user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    it_behaves_like 'API V3 collection response', 2, 2, 'PlaceholderUser'
  end

  describe 'user with manage_members permission' do
    let(:project) { FactoryBot.create(:project) }
    let(:user) { FactoryBot.create(:user, member_in_project: project, member_with_permissions: %i[manage_members]) }

    it_behaves_like 'API V3 collection response', 2, 2, 'PlaceholderUser'
  end

  describe 'unauthorized user' do
    let(:user) { FactoryBot.build(:user) }

    it_behaves_like 'API V3 collection response', 0, 0, 'PlaceholderUser'
  end
end
