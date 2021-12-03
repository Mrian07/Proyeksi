

require 'spec_helper'
require 'rack/test'

describe 'API v3 memberships available projects resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user)
  end
  let(:other_user) do
    FactoryBot.create(:user)
  end
  let(:own_member) do
    FactoryBot.create(:member,
                      roles: [FactoryBot.create(:role, permissions: permissions)],
                      project: project,
                      user: current_user)
  end
  let(:permissions) { %i[view_members manage_members] }
  let(:manage_project) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: permissions)],
                        project: p,
                        user: current_user)
    end
  end
  let(:membered_project) do
    FactoryBot.create(:project).tap do |p|
      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: permissions)],
                        project: p,
                        user: current_user)

      FactoryBot.create(:member,
                        roles: [FactoryBot.create(:role, permissions: permissions)],
                        project: p,
                        user: other_user)
    end
  end
  let(:unauthorized_project) do
    FactoryBot.create(:public_project)
  end

  subject(:response) { last_response }

  describe 'GET api/v3/memberships/available_projects' do
    let(:projects) { [manage_project, unauthorized_project] }

    before do
      projects
      login_as(current_user)

      get path
    end

    let(:path) { api_v3_paths.memberships_available_projects }
    let(:filter_path) { "#{api_v3_paths.memberships_available_projects}?#{{ filters: filters.to_json }.to_query}" }

    context 'without params' do
      it 'responds 200 OK' do
        expect(subject.status).to eq(200)
      end

      it 'returns a collection of projects containing only the ones for which the user has :manage_members permission' do
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

    context 'invalid filter' do
      let(:members) { [own_member] }

      let(:filters) do
        [{ 'bogus' => {
          'operator' => '=',
          'values' => ['1']
        } }]
      end

      let(:path) { filter_path }

      it 'returns an error' do
        expect(subject.status).to eq(400)

        expect(subject.body)
          .to be_json_eql('urn:proyeksiapp-org:api:v3:errors:InvalidQuery'.to_json)
          .at_path('errorIdentifier')
      end
    end

    context 'without permissions' do
      let(:permissions) { [:view_members] }

      it 'returns a 403' do
        expect(subject.status)
          .to eq(403)
      end
    end
  end
end
