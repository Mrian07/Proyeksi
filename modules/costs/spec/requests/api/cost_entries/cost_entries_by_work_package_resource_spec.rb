

require 'spec_helper'
require 'rack/test'

describe 'API v3 Cost Entry resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:work_package_permissions) { [:view_work_packages] }
  let(:cost_entry_permissions) { [:view_cost_entries] }
  let(:permissions) { work_package_permissions + cost_entry_permissions }
  let(:project) { FactoryBot.create(:project) }
  let(:work_package) { FactoryBot.create(:work_package, project: project) }
  subject(:response) { last_response }

  let(:cost_entry) do
    FactoryBot.create(:cost_entry,
                      project: project,
                      work_package: work_package,
                      user: current_user)
  end

  before do
    login_as current_user

    get get_path
  end

  describe 'work_packages/:id/cost_entries' do
    let(:get_path) { api_v3_paths.cost_entries_by_work_package work_package.id }

    context 'user can see any cost entries' do
      it 'should return HTTP 200' do
        expect(response.status).to eql(200)
      end
    end

    context 'user can see own cost entries' do
      let(:cost_entry_permissions) { [:view_own_cost_entries] }
      it 'should return HTTP 200' do
        expect(response.status).to eql(200)
      end
    end

    context 'user has no cost entry permissions' do
      let(:cost_entry_permissions) { [] }

      it_behaves_like 'error response',
                      403,
                      'MissingPermission',
                      I18n.t('api_v3.errors.code_403')
    end
  end

  describe 'work_packages/:id/summarized_costs_by_type' do
    let(:get_path) { api_v3_paths.summarized_work_package_costs_by_type work_package.id }

    context 'user can see any cost entries' do
      it 'should return HTTP 200' do
        expect(response.status).to eql(200)
      end
    end

    context 'user can see own cost entries' do
      let(:cost_entry_permissions) { [:view_own_cost_entries] }

      it 'should return HTTP 200' do
        expect(response.status).to eql(200)
      end
    end

    context 'user has no cost entry permissions' do
      let(:cost_entry_permissions) { [] }

      it_behaves_like 'error response',
                      403,
                      'MissingPermission',
                      I18n.t('api_v3.errors.code_403')
    end
  end
end
