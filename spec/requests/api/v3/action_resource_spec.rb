

require 'spec_helper'
require 'rack/test'

describe 'API v3 action resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  subject(:response) { last_response }

  current_user do
    FactoryBot.create(:user)
  end

  describe 'GET api/v3/actions' do
    let(:path) { api_v3_paths.actions }

    before do
      get path
    end

    it 'returns a collection of actions' do
      expect(subject.body)
        .to be_json_eql(Action.count.to_json)
        .at_path('total')

      expect(subject.body)
        .to be_json_eql(Action.order(id: :asc).first.id.to_json)
        .at_path('_embedded/elements/0/id')

      expect(subject.body)
        .to be_json_eql(Action.order(id: :asc).first.id.to_json)
        .at_path("_embedded/elements/0/id")
    end
  end

  describe 'GET /api/v3/actions/:id' do
    let(:path) { api_v3_paths.action("memberships/create") }

    before do
      get path
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql(200)
    end

    it 'returns the action' do
      expect(subject.body)
        .to be_json_eql('Action'.to_json)
        .at_path('_type')

      expect(subject.body)
        .to be_json_eql("memberships/create".to_json)
        .at_path('id')
    end

    context 'with an action that has an underscore' do
      let(:path) { api_v3_paths.action("work_packages/read") }

      it 'returns 200 OK' do
        expect(subject.status)
          .to eql(200)
      end

      it 'returns the action' do
        expect(subject.body)
          .to be_json_eql('Action'.to_json)
                .at_path('_type')

        expect(subject.body)
          .to be_json_eql("work_packages/read".to_json)
                .at_path('id')
      end
    end

    context 'if querying a non existing action' do
      let(:path) { api_v3_paths.action("foo/bar") }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to be 404
      end
    end

    context 'if querying with malformed id' do
      let(:path) { api_v3_paths.action("foobar") }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to be 404
      end
    end
  end
end
