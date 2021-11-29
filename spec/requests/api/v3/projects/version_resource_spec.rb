

require 'spec_helper'
require 'rack/test'

describe "API v3 project's versions resource" do
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
  let(:project) { FactoryBot.create(:project, public: false) }
  let(:other_project) { FactoryBot.create(:project, public: false) }
  let(:versions) { FactoryBot.create_list(:version, 4, project: project) }
  let(:other_versions) { FactoryBot.create_list(:version, 2) }

  subject(:response) { last_response }

  describe '#get (index)' do
    let(:get_path) { api_v3_paths.versions_by_project project.id }

    context 'logged in user' do
      before do
        current_user

        versions
        other_versions

        get get_path
      end

      it_behaves_like 'API V3 collection response', 4, 4, 'Version'
    end

    context 'logged in user without permission' do
      let(:role) { FactoryBot.create(:role, permissions: []) }

      before do
        current_user

        get get_path
      end

      it_behaves_like 'unauthorized access'
    end
  end
end
