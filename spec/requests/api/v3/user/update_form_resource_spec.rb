

require 'spec_helper'
require 'rack/test'

describe ::API::V3::Users::UpdateFormAPI, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:text_custom_field) do
    FactoryBot.create(:string_user_custom_field)
  end
  shared_let(:list_custom_field) do
    FactoryBot.create(:list_user_custom_field)
  end
  shared_let(:user) do
    FactoryBot.create(:user,
                      "custom_field_#{text_custom_field.id}": "CF text",
                      "custom_field_#{list_custom_field.id}": list_custom_field.custom_options.first)
  end

  let(:path) { api_v3_paths.user_form(user.id) }
  let(:payload) do
    {}
  end

  before do
    login_as(current_user)

    post path, payload.to_json
  end

  subject(:response) { last_response }
  let(:body) { response.body }

  context 'with authorized user' do
    shared_let(:current_user) do
      FactoryBot.create(:user, global_permission: :manage_user)
    end

    describe 'empty payload' do
      it 'returns a valid form', :aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(body)
          .to be_json_eql(user.mail.to_json)
                .at_path('_embedded/payload/email')

        expect(body)
          .to be_json_eql(user.firstname.to_json)
                .at_path('_embedded/payload/firstName')

        expect(body)
          .to be_json_eql(user.lastname.to_json)
                .at_path('_embedded/payload/lastName')

        expect(body)
          .to have_json_size(0)
                .at_path('_embedded/validationErrors')
      end
    end

    describe 'with a non-writable status' do
      let(:payload) do
        {
          "status": 'locked'
        }
      end

      it 'returns an invalid form', :aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(subject.body)
          .to have_json_size(1)
                .at_path('_embedded/validationErrors')

        expect(subject.body)
          .to have_json_path('_embedded/validationErrors/status')

        expect(body)
          .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyIsReadOnly'.to_json)
                .at_path('_embedded/validationErrors/status/errorIdentifier')

        # Does not change the user's status
        user.reload
        expect(user.status).to eq 'active'
      end
    end

    describe 'with an empty firstname' do
      let(:payload) do
        {
          "firstName": nil
        }
      end

      it 'returns an invalid form', :aggregate_failures do
        expect(response.status).to eq(200)
        expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')

        expect(body)
          .to be_json_eql(user.mail.to_json)
                .at_path('_embedded/payload/email')

        expect(body)
          .to_not have_json_path('_embedded/payload/firstName')

        expect(body)
          .to be_json_eql(user.lastname.to_json)
                .at_path('_embedded/payload/lastName')

        expect(subject.body)
          .to have_json_size(1)
                .at_path('_embedded/validationErrors')

        expect(subject.body)
          .to have_json_path('_embedded/validationErrors/firstName')

        expect(subject.body)
          .not_to have_json_path('_links/commit')

        name_before = user.name

        expect(user.reload.name)
          .to eql name_before
      end
    end

    context 'with a non existing id' do
      let(:path) { api_v3_paths.user_form(12345) }

      it 'returns 404 Not found' do
        expect(response.status).to eq(404)
      end
    end
  end

  context 'with unauthorized user' do
    let(:current_user) { FactoryBot.create :user }

    it_behaves_like 'unauthorized access'
  end

end
