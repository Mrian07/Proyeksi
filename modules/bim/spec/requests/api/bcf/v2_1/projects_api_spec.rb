

require 'spec_helper'
require 'rack/test'

require_relative './shared_responses'

describe 'BCF 2.1 projects resource', type: :request, content_type: :json do
  include Rack::Test::Methods

  let(:view_only_user) do
    FactoryBot.create(:user,
                      member_in_project: project)
  end
  let(:edit_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: [:edit_project])
  end
  let(:non_member_user) do
    FactoryBot.create(:user)
  end

  let(:project) { FactoryBot.create(:project, enabled_module_names: [:bim]) }

  subject(:response) { last_response }

  describe 'GET /api/bcf/2.1/projects/:project_id' do
    let(:path) { "/api/bcf/2.1/projects/#{project.id}" }
    let(:current_user) { view_only_user }

    before do
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        {
          project_id: project.id,
          name: project.name
        }
      end
    end

    context 'lacking permissions' do
      let(:current_user) { non_member_user }

      it_behaves_like 'bcf api not found response'
    end
  end

  describe 'PUT /api/bcf/2.1/projects/:project_id' do
    let(:path) { "/api/bcf/2.1/projects/#{project.id}" }
    let(:current_user) { edit_user }

    let(:params) do
      {
        name: 'new project name'
      }
    end

    before do
      login_as(current_user)
      put path, params.to_json
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        {
          project_id: project.id,
          name: 'new project name'
        }
      end
    end

    context 'lacking view permissions' do
      let(:current_user) { non_member_user }

      it_behaves_like 'bcf api not found response'
    end

    context 'lacking edit permissions' do
      let(:current_user) { view_only_user }

      it_behaves_like 'bcf api not allowed response'
    end

    context 'attempting to alter the id' do
      let(:params) do
        {
          project_id: 0
        }
      end

      it_behaves_like 'bcf api unprocessable response' do
        let(:message) { 'ID was attempted to be written but is not writable.' }
      end
    end
  end

  describe 'GET /api/bcf/2.1/projects' do
    let(:path) { "/api/bcf/2.1/projects" }
    let(:current_user) { view_only_user }
    let!(:invisible_project) { FactoryBot.create(:project, enabled_module_names: [:bcf]) }
    let!(:non_bcf_project) do
      FactoryBot.create(:project, enabled_module_names: [:work_packages]).tap do |p|
        FactoryBot.create(:member,
                          project: p,
                          user: view_only_user,
                          roles: view_only_user.members.first.roles)
      end
    end

    before do
      login_as(current_user)
      get path
    end

    it_behaves_like 'bcf api successful response' do
      let(:expected_body) do
        [
          {
            project_id: project.id,
            name: project.name
          }
        ]
      end
    end
  end
end
