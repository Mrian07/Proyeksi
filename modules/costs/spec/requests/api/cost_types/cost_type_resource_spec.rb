

require 'spec_helper'
require 'rack/test'

describe 'API v3 Cost Type resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: [:view_cost_entries]) }
  let(:project) { FactoryBot.create(:project) }
  subject(:response) { last_response }

  let!(:cost_type) { FactoryBot.create(:cost_type) }

  before do
    allow(User).to receive(:current).and_return current_user

    get get_path
  end

  describe 'cost_types/:id' do
    let(:get_path) { api_v3_paths.cost_type cost_type.id }

    context 'user can see cost entries' do
      context 'valid id' do
        it 'should return HTTP 200' do
          expect(response.status).to eql(200)
        end
      end

      context 'cost type deleted' do
        let!(:cost_type) { FactoryBot.create(:cost_type, :deleted) }

        it_behaves_like 'not found'
      end

      context 'invalid id' do
        let(:get_path) { api_v3_paths.cost_type 'bogus' }

        it_behaves_like 'param validation error' do
          let(:id) { 'bogus' }
        end
      end
    end

    context 'user can\'t see cost entries' do
      let(:current_user) { FactoryBot.create(:user) }

      it_behaves_like 'error response',
                      403,
                      'MissingPermission',
                      I18n.t('api_v3.errors.code_403')
    end
  end
end
