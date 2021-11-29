

require 'spec_helper'
require 'rack/test'

describe 'API v3 roles resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:role) do
    FactoryBot.create(:role,
                      permissions: permissions)
  end
  let(:permissions) { %i[view_members manage_members] }
  let(:project) { FactoryBot.create(:project) }

  subject(:response) { last_response }

  describe 'GET api/v3/roles' do
    let(:get_path) { api_v3_paths.roles }
    let(:response) { last_response }
    let(:roles) { [role] }

    before do
      roles

      login_as(current_user)

      get get_path
    end

    it 'succeeds' do
      expect(last_response.status)
        .to eql(200)
    end

    it_behaves_like 'API V3 collection response', 1, 1, 'Role'

    context 'filtering by assignable' do
      let(:filters) do
        [{ grantable: { operator: '=', values: ['t'] } }]
      end

      let(:non_member_role) { Role.non_member }
      let(:roles) { [role, non_member_role] }

      let(:get_path) { api_v3_paths.path_for(:roles, filters: filters) }

      it 'contains only the filtered member in the response' do
        expect(subject.body)
          .to be_json_eql('1')
          .at_path('total')

        expect(subject.body)
          .to be_json_eql(role.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end

    context 'filtering by unit' do
      let(:filters) do
        [{ 'unit' => {
          'operator' => '=',
          'values' => ['project']
        } }]
      end

      let(:non_member_role) { Role.non_member }
      let(:global_role) { FactoryBot.create(:global_role) }
      let(:roles) { [role, non_member_role, global_role] }

      let(:get_path) { api_v3_paths.path_for(:roles, filters: filters) }

      it 'contains only the filtered member in the response' do
        expect(subject.body)
          .to be_json_eql('1')
          .at_path('total')

        expect(subject.body)
          .to be_json_eql(role.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end

    context 'without the necessary permissions' do
      let(:permissions) { [] }

      it 'returns 403' do
        expect(subject.status)
          .to eql(403)
      end
    end
  end

  describe 'GET /api/v3/roles/:id' do
    let(:path) { api_v3_paths.role(role.id) }

    let(:roles) { [role] }

    before do
      roles

      login_as(current_user)

      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the member' do
      expect(subject.body)
        .to be_json_eql('Role'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(role.id.to_json)
        .at_path('id')
    end

    context 'if querying an non existent' do
      let(:path) { api_v3_paths.role(0) }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql(404)
      end
    end

    context 'without the necessary permissions' do
      let(:permissions) { [] }

      it 'returns 403' do
        expect(subject.status)
          .to eql(403)
      end
    end
  end
end
