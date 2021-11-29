

require 'spec_helper'
require 'rack/test'

describe 'API v3 news resource', type: :request do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:news) do
    FactoryBot.create(:news, project: project, author: current_user)
  end
  let(:other_news) do
    FactoryBot.create(:news, project: project, author: other_user)
  end
  let(:other_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:invisible_news) do
    FactoryBot.create(:news, project: other_project, author: other_user)
  end
  let(:project) { FactoryBot.create(:project) }
  let(:other_project) { FactoryBot.create(:project) }
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i(view_news) }

  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe 'GET api/v3/news' do
    let(:path) { api_v3_paths.newses }

    context 'without params' do
      before do
        news
        invisible_news

        get path
      end

      it 'responds 200 OK' do
        expect(subject.status).to eq(200)
      end

      it 'returns a collection of news containing only the visible ones' do
        expect(subject.body)
          .to be_json_eql('Collection'.to_json)
          .at_path('_type')

        expect(subject.body)
          .to be_json_eql('1')
          .at_path('total')

        expect(subject.body)
          .to be_json_eql(news.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end

    context 'with pageSize, offset and sortBy' do
      let(:path) { "#{api_v3_paths.newses}?pageSize=1&offset=2&sortBy=#{[%i(id asc)].to_json}" }

      before do
        news
        other_news
        invisible_news

        get path
      end

      it 'returns a slice of the news' do
        expect(subject.body)
          .to be_json_eql('Collection'.to_json)
          .at_path('_type')

        expect(subject.body)
          .to be_json_eql('2')
          .at_path('total')

        expect(subject.body)
          .to be_json_eql('1')
          .at_path('count')

        expect(subject.body)
          .to be_json_eql(other_news.id.to_json)
          .at_path('_embedded/elements/0/id')
      end
    end
  end

  describe 'GET /api/v3/news/:id' do
    let(:path) { api_v3_paths.news(news.id) }

    before do
      news

      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the news' do
      expect(subject.body)
        .to be_json_eql('News'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql(news.id.to_json)
        .at_path('id')
    end

    context 'when lacking permissions' do
      let(:path) { api_v3_paths.news(invisible_news.id) }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql(404)
      end
    end
  end
end
