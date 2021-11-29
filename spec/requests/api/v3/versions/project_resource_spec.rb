

require 'spec_helper'
require 'rack/test'

describe "API v3 version's projects resource" do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    user = FactoryBot.create(:user,
                             member_in_project: project,
                             member_through_role: role)

    allow(User).to receive(:current).and_return user

    user
  end
  let(:role) { FactoryBot.create(:role, permissions: [:view_work_packages]) }
  let(:role_without_permissions) { FactoryBot.create(:role, permissions: []) }
  let(:project) { FactoryBot.create(:project, public: false) }
  let(:project2) { FactoryBot.create(:project, public: false) }
  let(:project3) { FactoryBot.create(:project, public: false) }
  let(:project4) { FactoryBot.create(:project, public: false) }
  let(:version) { FactoryBot.create(:version, project: project, sharing: 'system') }

  subject(:response) { last_response }

  describe '#get (index)' do
    let(:get_path) { api_v3_paths.projects_by_version version.id }

    context 'logged in user with permissions' do
      before do
        current_user

        # this is to be included
        FactoryBot.create(:member, user: current_user,
                                   project: project2,
                                   roles: [role])
        # this is to be included as the user is a member of the project, the
        # lack of permissions is irrelevant.
        FactoryBot.create(:member, user: current_user,
                                   project: project3,
                                   roles: [role_without_permissions])
        # project4 should NOT be included
        project4

        get get_path
      end

      it_behaves_like 'API V3 collection response', 3, 3, 'Project'

      it 'includes only the projects which the user can see' do
        id_in_response = JSON.parse(response.body)['_embedded']['elements'].map { |p| p['id'] }

        expect(id_in_response).to match_array [project.id, project2.id, project3.id]
      end
    end

    context 'logged in user without permissions' do
      let(:role) { role_without_permissions }

      before do
        current_user

        get get_path
      end

      it_behaves_like 'not found'
    end
  end
end
