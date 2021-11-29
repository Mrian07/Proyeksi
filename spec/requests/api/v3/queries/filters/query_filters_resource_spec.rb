

require 'spec_helper'
require 'rack/test'

describe 'API v3 Query Filter resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  describe '#get queries/filters/:id' do
    let(:path) { api_v3_paths.query_filter(filter_name) }
    let(:filter_name) { 'assignee' }
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

    it 'returns the filter' do
      expect(last_response.body)
        .to be_json_eql(path.to_json)
        .at_path('_links/self/href')
    end

    context 'user not allowed' do
      let(:permissions) { [] }

      it_behaves_like 'unauthorized access'
    end

    context 'non existing filter' do
      let(:filter_name) { 'bogus' }

      it 'returns 404' do
        expect(last_response.status)
          .to eql(404)
      end
    end

    context 'custom field filter' do
      let(:list_wp_custom_field) { FactoryBot.create(:list_wp_custom_field) }
      let(:filter_name) { "customField#{list_wp_custom_field.id}" }

      it 'succeeds' do
        expect(last_response.status)
          .to eq(200)
      end

      it 'returns the filter' do
        expect(last_response.body)
          .to be_json_eql(path.to_json)
          .at_path('_links/self/href')
      end
    end
  end
end
