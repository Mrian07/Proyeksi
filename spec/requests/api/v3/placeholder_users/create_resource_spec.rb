

require 'spec_helper'
require 'rack/test'
require_relative './create_shared_examples'

describe ::API::V3::PlaceholderUsers::PlaceholderUsersAPI,
         'create',
         type: :request do

  current_user { user }

  describe 'admin user' do
    let(:user) { FactoryBot.build(:admin) }

    it_behaves_like 'create placeholder user request flow'
  end

  describe 'user with manage_placeholder_user permission' do
    let(:user) { FactoryBot.create(:user, global_permission: %i[manage_placeholder_user]) }

    it_behaves_like 'create placeholder user request flow'
  end

  describe 'unauthorized user' do
    include_context 'create placeholder user request context'
    let(:user) { FactoryBot.build(:user) }

    it 'returns an erroneous response' do
      send_request
      expect(last_response.status).to eq(403)
    end
  end
end
