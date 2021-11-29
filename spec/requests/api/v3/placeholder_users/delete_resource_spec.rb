

require 'spec_helper'
require_relative './delete_resource_examples'

describe ::API::V3::PlaceholderUsers::PlaceholderUsersAPI,
         'delete',
         type: :request do
  include API::V3::Utilities::PathHelper

  shared_let(:placeholder) { FactoryBot.create :placeholder_user, name: 'foo' }

  let(:send_request) do
    header "Content-Type", "application/json"
  end

  let(:path) { api_v3_paths.placeholder_user(placeholder.id) }
  let(:parsed_response) { JSON.parse(last_response.body) }

  current_user { user }

  before do
    header "Content-Type", "application/json"
    delete path
  end

  context 'when admin' do
    let(:user) { FactoryBot.build_stubbed :admin }

    it_behaves_like 'deletion allowed'
  end

  context 'when locked admin' do
    let(:user) { FactoryBot.build_stubbed :admin, status: Principal.statuses[:locked] }

    it_behaves_like 'deletion is not allowed'
  end

  context 'when non-admin' do
    let(:user) { FactoryBot.build_stubbed :user, admin: false }

    it_behaves_like 'deletion is not allowed'
  end

  context 'when user with manage_user permission' do
    let(:user) { FactoryBot.create :user, global_permission: %[manage_placeholder_user] }

    it_behaves_like 'deletion allowed'
  end

  context 'when anonymous user' do
    let(:user) { FactoryBot.create :anonymous }

    it_behaves_like 'deletion is not allowed'
  end
end
