

require 'spec_helper'
require 'rack/test'

describe 'API v3 wiki_pages resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:other_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:wiki) { FactoryBot.create(:wiki, project: project) }
  let(:wiki_page) { FactoryBot.create(:wiki_page, wiki: wiki) }
  let(:project) { FactoryBot.create(:project) }
  let(:other_wiki) { FactoryBot.create(:wiki, project: other_project) }
  let(:other_wiki_page) { FactoryBot.create(:wiki_page, wiki: other_wiki) }
  let(:other_project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i(view_wiki_pages) }

  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe 'GET /api/v3/wiki_pages/:id' do
    let(:path) { api_v3_paths.wiki_page(wiki_page.id) }

    before do
      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the wiki page' do
      expect(subject.body)
        .to be_json_eql('WikiPage'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(wiki_page.id.to_json)
        .at_path('id')
    end

    context 'when lacking permissions' do
      let(:permissions) { [] }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql(404)
      end
    end
  end
end
