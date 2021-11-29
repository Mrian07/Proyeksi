

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query Column resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  describe '#get queries/columns/:id' do
    let(:path) { api_v3_paths.query_column(column_name) }
    let(:column_name) { 'status' }
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
        .to eq(200)
    end

    it 'returns the column' do
      expect(last_response.body)
        .to be_json_eql(path.to_json)
        .at_path('_links/self/href')
    end

    context 'user not allowed' do
      let(:permissions) { [] }

      it_behaves_like 'unauthorized access'
    end

    context 'non existing group by' do
      let(:path) { api_v3_paths.query_column('bogus') }

      it 'returns 404' do
        expect(last_response.status)
          .to eql(404)
      end
    end
  end
end
