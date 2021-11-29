

require 'spec_helper'
require 'rack/test'

describe ::API::V3::Users::CreateFormAPI, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:path) { api_v3_paths.create_user_form }

  before do
    login_as(current_user)

    post path, payload.to_json
  end

  subject(:response) { last_response }
  let(:body) { response.body }

  context 'with authorized user' do
    shared_let(:current_user) { FactoryBot.create :user, global_permission: :manage_user }

    describe 'empty params' do
      let(:payload) do
        {}
      end

      it 'returns a payload with validation errors', :aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(body)
          .to be_json_eql(''.to_json)
                .at_path('_embedded/payload/login')
        expect(body)
          .to be_json_eql(''.to_json)
                .at_path('_embedded/payload/email')
        expect(body)
          .to be_json_eql(''.to_json)
                .at_path('_embedded/payload/language')
        expect(body)
          .to be_json_eql('active'.to_json)
                .at_path('_embedded/payload/status')

        expect(body)
          .to have_json_size(5)
                .at_path('_embedded/validationErrors')

        expect(body)
          .to have_json_path('_embedded/validationErrors/password')

        expect(body)
          .to have_json_path('_embedded/validationErrors/login')

        expect(body)
          .to have_json_path('_embedded/validationErrors/email')

        expect(body)
          .to have_json_path('_embedded/validationErrors/firstName')

        expect(body)
          .to have_json_path('_embedded/validationErrors/lastName')

        expect(body)
          .not_to have_json_path('_links/commit')
      end
    end

    describe 'inviting a user' do
      let(:payload) do
        {
          email: 'foo@example.com',
          status: 'invited'
        }
      end

      it 'returns a valid payload', :aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(body)
          .to be_json_eql('invited'.to_json)
                .at_path('_embedded/payload/status')

        expect(body)
          .to be_json_eql('foo@example.com'.to_json)
                .at_path('_embedded/payload/email')

        expect(body)
          .to be_json_eql('foo'.to_json)
                .at_path('_embedded/payload/firstName')

        expect(body)
          .to be_json_eql('@example.com'.to_json)
                .at_path('_embedded/payload/lastName')

        expect(body)
          .to have_json_size(0)
                .at_path('_embedded/validationErrors')
      end
    end

    describe 'with custom fields' do
      let!(:custom_field) do
        FactoryBot.create(:string_user_custom_field)
      end
      let!(:list_custom_field) do
        FactoryBot.create(:list_user_custom_field)
      end
      let(:custom_option_href) { api_v3_paths.custom_option(list_custom_field.custom_options.first.id) }

      let(:payload) do
        {
          email: 'cfuser@example.com',
          status: 'invited',
          "customField#{custom_field.id}": "A custom value",
          "_links": {
            "customField#{list_custom_field.id}": {
              "href": custom_option_href
            }
          }
        }
      end

      it 'returns a valid form response' do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(body)
          .to be_json_eql('invited'.to_json)
                .at_path('_embedded/payload/status')

        expect(body)
          .to be_json_eql('cfuser@example.com'.to_json)
                .at_path('_embedded/payload/email')

        expect(body)
          .to be_json_eql('cfuser'.to_json)
                .at_path('_embedded/payload/firstName')

        expect(body)
          .to be_json_eql('@example.com'.to_json)
                .at_path('_embedded/payload/lastName')

        expect(body)
          .to be_json_eql('A custom value'.to_json)
                .at_path("_embedded/payload/customField#{custom_field.id}")

        expect(body)
          .to be_json_eql(custom_option_href.to_json)
                .at_path("_embedded/payload/_links/customField#{list_custom_field.id}/href")

        expect(body)
          .to have_json_size(0)
                .at_path('_embedded/validationErrors')
      end
    end
  end

  context 'with unauthorized user' do
    shared_let(:current_user) { FactoryBot.create :user }
    let(:payload) do
      {}
    end

    it_behaves_like 'unauthorized access'
  end
end
