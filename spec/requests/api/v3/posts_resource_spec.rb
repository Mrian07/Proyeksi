

require 'spec_helper'
require 'rack/test'

describe 'API v3 posts resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:forum) { FactoryBot.create(:forum, project: project) }
  let(:message) { FactoryBot.create(:message, forum: forum) }
  let(:project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i(view_messages) }

  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe 'GET /api/v3/posts/:id' do
    let(:path) { api_v3_paths.post(message.id) }

    before do
      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the message page' do
      expect(subject.body)
        .to be_json_eql('Post'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(message.id.to_json)
        .at_path('id')
    end

    context 'when lacking permissions' do
      let(:current_user) { FactoryBot.create(:user) }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql(404)
      end
    end
  end
end
