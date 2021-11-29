

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project, identifier: 'test_project', public: false) }
  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { [:view_work_packages] }

  before do
    allow(User).to receive(:current).and_return current_user
  end

  describe '#get projects/:project_id/queries/default' do
    let(:base_path) { api_v3_paths.query_project_default(project.id) }

    it_behaves_like 'GET individual query' do
      context 'lacking permissions' do
        let(:permissions) { [] }

        it_behaves_like 'unauthorized access'
      end
    end
  end
end
