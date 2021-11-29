

require 'spec_helper'
require 'rack/test'

describe 'API v3 members available projects resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user)
  end
  let(:own_member) do
    FactoryBot.create(:member,
                      roles: [FactoryBot.create(:role, permissions: permissions)],
                      project: project,
                      user: current_user)
  end
  let(:permissions) { %i[view_versions manage_versions] }
  let(:manage_project) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: permissions)],
                        project: p,
                        user: current_user)
    end
  end
  let(:view_project) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: [:view_versions])],
                        project: p,
                        user: current_user)
    end
  end
  # let(:membered_project) do
  #  FactoryBot.create(:project).tap do |p|
  #    FactoryBot.create(:member,
  #                      roles: [FactoryBot.create(:role, permissions: permissions)],
  #                      project: p,
  #                      user: current_user)

  #    FactoryBot.create(:member,
  #                      roles: [FactoryBot.create(:role, permissions: permissions)],
  #                      project: p,
  #                      user: other_user)
  #  end
  # end
  let(:unauthorized_project) do
    FactoryBot.create(:public_project)
  end

  subject(:response) { last_response }

  describe 'GET api/v3/members/available_projects' do
    let(:projects) { [manage_project, view_project, unauthorized_project] }

    before do
      projects
      login_as(current_user)

      get path
    end

    let(:path) { api_v3_paths.versions_available_projects }

    context 'without params' do
      it 'responds 200 OK' do
        expect(subject.status).to eq(200)
      end

      it 'returns a collection of projects containing only the ones for which the user has :manage_versions permission' do
        expect(subject.body)
          .to be_json_eql('Collection'.to_json)
          .at_path('_type')

        expect(subject.body)
          .to be_json_eql('1')
          .at_path('total')

        expect(subject.body)
          .to be_json_eql(manage_project.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end

    context 'without permissions' do
      let(:permissions) { [:view_versions] }

      it 'returns a 403' do
        expect(subject.status)
          .to eq(403)
      end
    end
  end
end
