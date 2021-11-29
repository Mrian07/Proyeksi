

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query Operator resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  describe '#get queries/operators/:id' do
    let(:path) { api_v3_paths.query_operator(CGI.escape(operator)) }
    let(:operator) { '=' }
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

    it 'returns the operator' do
      expect(last_response.body)
        .to be_json_eql(path.to_json)
        .at_path('_links/self/href')
    end

    context 'user not allowed' do
      let(:permissions) { [] }

      it_behaves_like 'unauthorized access'
    end

    context 'non existing operator' do
      let(:operator) { 'bogus' }

      it 'returns 404' do
        expect(last_response.status)
          .to eql(404)
      end
    end
  end
end