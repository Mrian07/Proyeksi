

require 'spec_helper'
require 'rack/test'

describe "PATCH /api/v3/grids/:id/form", type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:current_user) do
    FactoryBot.create(:user)
  end

  let(:grid) do
    FactoryBot.create(:my_page, user: current_user)
  end
  let(:path) { api_v3_paths.grid_form(grid.id) }
  let(:params) { {} }
  subject(:response) { last_response }

  before do
    login_as(current_user)
  end

  describe '#post' do
    before do
      post path, params.to_json, 'CONTENT_TYPE' => 'application/json'
    end

    it 'returns 200 OK' do
      expect(subject.status)
        .to eql 200
    end

    it 'is of type form' do
      expect(subject.body)
        .to be_json_eql("Form".to_json)
        .at_path('_type')
    end

    it 'contains a Schema disallowing setting scope' do
      expect(subject.body)
        .to be_json_eql("Schema".to_json)
        .at_path('_embedded/schema/_type')

      expect(subject.body)
        .to be_json_eql(false.to_json)
        .at_path('_embedded/schema/scope/writable')
    end

    it 'contains the current data in the payload' do
      expected = {
        rowCount: 7,
        columnCount: 4,
        options: {},
        widgets: [
          {
            "_type": "GridWidget",
            identifier: 'news',
            options: {},
            startRow: 1,
            endRow: 7,
            startColumn: 1,
            endColumn: 3
          },
          {
            "_type": "GridWidget",
            identifier: 'documents',
            options: {},
            startRow: 1,
            endRow: 7,
            startColumn: 3,
            endColumn: 5
          }
        ],
        "_links": {
          "attachments": [],
          "scope": {
            "href": "/my/page",
            "type": "text/html"
          }
        }
      }

      expect(subject.body)
        .to be_json_eql(expected.to_json)
        .at_path('_embedded/payload')
    end

    it 'has a commit link' do
      expect(subject.body)
        .to be_json_eql(api_v3_paths.grid(grid.id).to_json)
        .at_path('_links/commit/href')
    end

    context 'with some value for the scope value' do
      let(:params) do
        {
          '_links': {
            'scope': {
              'href': '/some/path'
            }
          }
        }
      end

      it 'has a validation error on scope as the value is not writeable' do
        expect(subject.body)
          .to be_json_eql("Scope was attempted to be written but is not writable.".to_json)
          .at_path('_embedded/validationErrors/scope/message')
      end
    end

    context 'with an unsupported widget identifier' do
      let(:params) do
        {
          "widgets": [
            {
              "_type": "GridWidget",
              "identifier": "bogus_identifier",
              "startRow": 4,
              "endRow": 5,
              "startColumn": 1,
              "endColumn": 2
            }
          ]
        }
      end

      it 'has a validationError on widget' do
        expect(subject.body)
          .to be_json_eql("Widgets is not set to one of the allowed values.".to_json)
          .at_path('_embedded/validationErrors/widgets/message')
      end
    end

    context 'for another user\'s grid' do
      let(:other_user) { FactoryBot.create(:user) }
      let(:other_grid) { FactoryBot.create(:my_page, user: other_user) }

      let(:path) { api_v3_paths.grid_form(other_grid.id) }

      it 'returns 404 NOT FOUND' do
        expect(subject.status)
          .to eql 404
      end
    end
  end
end
