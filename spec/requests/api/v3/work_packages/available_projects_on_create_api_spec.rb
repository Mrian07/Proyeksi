

require 'spec_helper'
require 'rack/test'

describe API::V3::WorkPackages::AvailableProjectsOnCreateAPI, type: :request do
  include API::V3::Utilities::PathHelper

  let(:add_role) do
    FactoryBot.create(:role, permissions: [:add_work_packages])
  end
  let(:project) { FactoryBot.create(:project) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: add_role)
  end
  let(:type_id) { nil }

  context 'with a type filter present' do
    let(:type) { FactoryBot.create :type }
    let(:type_id) { type.id }
    let(:project_with_type) { FactoryBot.create :project, types: [type] }
    let(:member) do
      FactoryBot.create(:member, principal: user, project: project_with_type, roles: [add_role])
    end

    before do
      project
      project_with_type
      member

      allow(User).to receive(:current).and_return(user)
      get api_v3_paths.available_projects_on_create(type_id)
    end

    it 'returns only the filtered one' do
      expect(last_response.body).to be_json_eql(1).at_path('total')
      expect(last_response.body).to be_json_eql(project_with_type.id).at_path('_embedded/elements/0/id')
    end
  end

  describe 'with a single project' do
    before do
      project

      allow(User).to receive(:current).and_return(user)
      get api_v3_paths.available_projects_on_create(type_id)
    end

    context 'w/ the necessary permissions' do
      it_behaves_like 'API V3 collection response', 1, 1, 'Project'

      it 'has the project for which the add_work_packages permission exists' do
        expect(last_response.body).to be_json_eql(project.id).at_path('_embedded/elements/0/id')
      end
    end

    context 'w/o any add_work_packages permission' do
      let(:add_role) do
        FactoryBot.create(:role, permissions: [])
      end

      it { expect(last_response.status).to eq(403) }
    end
  end
end
