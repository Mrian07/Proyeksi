

require 'spec_helper'
require 'rack/test'

describe 'API v3 time entries available projects resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user)
  end
  let(:other_user) do
    FactoryBot.create(:user)
  end
  let(:project_with_log_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [:log_time])],
                        project: p,
                        user: current_user)
    end
  end
  let(:project_with_edit_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [:edit_time_entries])],
                        project: p,
                        user: current_user)
    end
  end
  let(:project_with_edit_own_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [:edit_own_time_entries])],
                        project: p,
                        user: current_user)
    end
  end
  let(:project_with_view_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [:view_time_entries])],
                        project: p,
                        user: current_user)
    end
  end
  let(:project_without_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [])],
                        project: p,
                        user: current_user)
    end
  end
  let(:project_without_membership) do
    FactoryBot.create(:project)
  end

  subject(:response) { last_response }

  describe 'GET api/v3/memberships/available_projects' do
    let(:projects) do
      [project_with_log_permission,
       project_with_edit_permission,
       project_with_edit_own_permission,
       project_with_view_permission,
       project_without_permission,
       project_without_membership]
    end

    before do
      projects
      login_as(current_user)

      get path
    end

    let(:path) { api_v3_paths.path_for(:time_entries_available_projects, sort_by: [%w(id asc)]) }

    it 'responds 200 OK' do
      expect(subject.status).to eq(200)
    end

    it 'returns a collection of projects containing only the ones for which the user has the necessary permissions' do
      expect(subject.body)
        .to be_json_eql('Collection'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql('3')
        .at_path('total')

      expect(subject.body)
        .to be_json_eql(project_with_log_permission.id.to_json)
        .at_path('_embedded/elements/0/id')

      expect(subject.body)
        .to be_json_eql(project_with_edit_permission.id.to_json)
        .at_path('_embedded/elements/1/id')

      expect(subject.body)
        .to be_json_eql(project_with_edit_own_permission.id.to_json)
        .at_path('_embedded/elements/2/id')
    end

    context 'without permissions' do
      let(:projects) do
        [project_with_view_permission,
         project_without_permission,
         project_without_membership]
      end

      it 'returns a 403' do
        expect(subject.status)
          .to eq(403)
      end
    end
  end
end
