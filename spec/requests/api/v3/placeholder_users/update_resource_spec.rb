

require 'spec_helper'
require_relative './update_resource_examples'

describe ::API::V3::PlaceholderUsers::PlaceholderUsersAPI,
         'update',
         type: :request do
  include API::V3::Utilities::PathHelper

  shared_let(:placeholder) { FactoryBot.create :placeholder_user, name: 'foo' }

  let(:parameters) do
    {}
  end

  let(:send_request) do
    header "Content-Type", "application/json"
    patch api_v3_paths.placeholder_user(placeholder.id), parameters.to_json
  end

  let(:parsed_response) { JSON.parse(last_response.body) }

  current_user { user }

  before do
    send_request
  end

  describe 'admin user' do
    let(:user) { FactoryBot.build(:admin) }

    it_behaves_like 'updates the placeholder'
  end

  describe 'user with manage_placeholder_user permission' do
    let(:user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    it_behaves_like 'updates the placeholder'
  end

  describe 'unauthorized user' do
    let(:user) { FactoryBot.build(:user) }

    it 'returns a 403 response' do
      expect(last_response.status).to eq(403)
    end
  end
end
