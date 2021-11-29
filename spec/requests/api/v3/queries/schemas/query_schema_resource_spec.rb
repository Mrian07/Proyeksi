

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query Schema resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

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
  end

  describe '#get queries/schema' do
    subject { last_response }

    let(:path) { api_v3_paths.query_schema }

    before do
      get path
    end

    it 'succeeds' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the schema' do
      expect(subject.body)
        .to be_json_eql(path.to_json)
        .at_path('_links/self/href')
    end

    context 'user not allowed' do
      let(:permissions) { [] }

      it_behaves_like 'unauthorized access'
    end
  end
end
