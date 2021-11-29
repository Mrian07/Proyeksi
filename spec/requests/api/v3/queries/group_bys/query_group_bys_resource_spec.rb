

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query Group By resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  describe '#get queries/group_bys/:id' do
    let(:path) { api_v3_paths.query_group_by(group_by_name) }
    let(:group_by_name) { 'status' }
    let(:project) { FactoryBot.create(:project) }
    let(:role) { FactoryBot.create(:role, permissions: permissions) }
    let(:permissions) { [:view_work_packages] }
    let(:user) do
      FactoryBot.create(:user,
                        member_in_project: project,
                        member_through_role: role)
    end

    before do
      allow(User)
        .to receive(:current)
        .and_return(user)

      get path
    end

    it 'succeeds' do
      expect(last_response.status)
        .to eql(200)
    end

    it 'returns the group_by' do
      expect(last_response.body)
        .to be_json_eql(path.to_json)
        .at_path('_links/self/href')
    end

    context 'user not allowed' do
      let(:permissions) { [] }

      it_behaves_like 'unauthorized access'
    end

    context 'non existing group by' do
      let(:path) { api_v3_paths.query_group_by('bogus') }

      it 'returns 404' do
        expect(last_response.status)
          .to eql(404)
      end
    end

    context 'non groupable group by' do
      let(:path) { api_v3_paths.query_group_by('id') }

      it 'returns 404' do
        expect(last_response.status)
          .to eql(404)
      end
    end
  end
end
