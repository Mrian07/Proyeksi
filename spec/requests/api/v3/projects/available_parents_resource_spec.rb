

require 'spec_helper'
require 'rack/test'

describe 'API v3 Project available parents resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  current_user do
    FactoryBot.create(:user, member_in_project: project, member_with_permissions: permissions).tap do |u|
      FactoryBot.create(:global_member,
                        principal: u,
                        roles: [FactoryBot.create(:global_role, permissions: global_permissions)])
    end
  end
  let(:project_with_add_subproject_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        user: current_user,
                        project: p,
                        roles: [FactoryBot.create(:role, permissions: [:add_subprojects])])
    end
  end
  let(:child_project_with_add_subproject_permission) do
    FactoryBot.create(:project, parent: project).tap do |p|
      FactoryBot.create(:member,
                        user: current_user,
                        project: p,
                        roles: [FactoryBot.create(:role, permissions: [:add_subprojects])])
    end
  end
  let(:project_without_add_subproject_permission) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        user: current_user,
                        project: p,
                        roles: [FactoryBot.create(:role, permissions: [])])
    end
  end
  let!(:project) do
    FactoryBot.create(:project, public: false)
  end
  let(:permissions) { %i[edit_project add_subprojects] }
  let(:global_permissions) { %i[add_project] }
  let(:path) { api_v3_paths.path_for(:projects_available_parents, sort_by: [%i[id asc]]) }
  let(:other_projects) do
    [project_with_add_subproject_permission,
     child_project_with_add_subproject_permission,
     project_without_add_subproject_permission]
  end

  describe 'GET /api/v3/projects/available_parent_projects' do
    subject(:response) do
      other_projects

      get path

      last_response
    end

    context 'without a project candidate' do
      it 'returns 200 OK' do
        expect(subject.status)
          .to eql 200
      end

      it 'returns projects for which the user has the add_subprojects permission' do
        expect(subject.body)
          .to have_json_size(3)
          .at_path('_embedded/elements')

        expect(subject.body)
          .to be_json_eql(project.id.to_json)
          .at_path('_embedded/elements/0/id')

        expect(subject.body)
          .to be_json_eql(project_with_add_subproject_permission.id.to_json)
          .at_path('_embedded/elements/1/id')

        expect(subject.body)
          .to be_json_eql(child_project_with_add_subproject_permission.id.to_json)
          .at_path('_embedded/elements/2/id')
      end
    end

    context 'with a project candidate' do
      let(:path) { api_v3_paths.projects_available_parents + "?of=#{project.id}" }

      it 'returns 200 OK' do
        expect(subject.status)
          .to eql 200
      end

      it 'returns projects for which the user has the add_subprojects permission but' +
         ' excludes the queried for project and it`s descendants' do
        expect(subject.body)
          .to have_json_size(1)
                .at_path('_embedded/elements')

        expect(subject.body)
          .to be_json_eql(project_with_add_subproject_permission.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end

    context 'when lacking edit and add permission' do
      let(:permissions) { %i[] }
      let(:global_permissions) { %i[] }
      let(:other_projects) do
        [project_without_add_subproject_permission]
      end

      it 'returns 403' do
        expect(subject.status)
          .to eql 403
      end
    end

    context 'when having only add_subprojects permission' do
      let(:permissions) { %i[add_subprojects] }
      let(:global_permissions) { %i[] }

      it 'returns 200' do
        expect(subject.status)
          .to eql 200
      end
    end

    context 'when having only edit permission' do
      let(:permissions) { %i[edit_project] }
      let(:global_permissions) { %i[] }

      it 'returns 200' do
        expect(subject.status)
          .to eql 200
      end
    end

    context 'when having only add_project permission' do
      let(:permissions) { %i[] }
      let(:global_permissions) { %i[add_project] }

      it 'returns 200' do
        expect(subject.status)
          .to eql 200
      end
    end
  end
end
