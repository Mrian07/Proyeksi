

require 'spec_helper'
require 'rack/test'

describe ::API::V3::Users::UsersAPI, type: :request do
  include API::V3::Utilities::PathHelper

  let(:path) { api_v3_paths.user(user.id) }

  let(:user) { FactoryBot.create(:user) }
  let(:parameters) { {} }

  before do
    login_as(current_user)
  end

  def send_request
    header "Content-Type", "application/json"
    patch path, parameters.to_json
  end

  shared_context 'successful update' do |expected_attributes|
    it 'responds with the represented updated user' do
      send_request

      expect(last_response.status).to eq(200)
      expect(last_response.body).to have_json_type(Object).at_path('_links')
      expect(last_response.body)
        .to be_json_eql('User'.to_json)
        .at_path('_type')

      updated_user = User.find(user.id)
      (expected_attributes || {}).each do |key, val|
        expect(updated_user.send(key)).to eq(val)
      end
    end
  end

  shared_examples 'update flow' do
    describe 'empty request body' do
      it_behaves_like 'successful update'
    end

    describe 'attribute change' do
      let(:parameters) { { email: 'foo@example.org', language: 'de' } }
      it_behaves_like 'successful update', mail: 'foo@example.org', language: 'de'
    end

    describe 'attribute collision' do
      let(:parameters) { { email: 'foo@example.org' } }
      let(:collision) { FactoryBot.create(:user, mail: 'foo@example.org') }
      before do
        collision
      end

      it 'returns an erroneous response' do
        send_request

        expect(last_response.status).to eq(422)

        expect(last_response.body)
          .to be_json_eql('email'.to_json)
                .at_path('_embedded/details/attribute')

        expect(last_response.body)
          .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyConstraintViolation'.to_json)
                .at_path('errorIdentifier')
      end
    end
  end

  describe 'admin user' do
    let(:current_user) { FactoryBot.build(:admin) }

    it_behaves_like 'update flow'

    describe 'password update' do
      let(:password) { 'my!new!password123' }
      let(:parameters) { { password: password } }

      it 'updates the users password correctly' do
        send_request
        expect(last_response.status).to eq(200)

        updated_user = User.find(user.id)
        matches = updated_user.check_password?(password)
        expect(matches).to eq(true)
      end
    end

    describe 'unknown user' do
      let(:parameters) { { email: 'foo@example.org' } }
      let(:path) { api_v3_paths.user(666) }

      it 'responds with 404' do
        send_request
        expect(last_response.status).to eql(404)
      end
    end
  end

  describe 'user with global manage_user permission' do
    shared_let(:global_manage_user) { FactoryBot.create :user, global_permission: :manage_user }
    let(:current_user) { global_manage_user }

    it_behaves_like 'update flow'

    describe 'password update' do
      let(:password) { 'my!new!password123' }
      let(:parameters) { { password: password } }

      it 'rejects the users password update' do
        send_request
        expect(last_response.status).to eq(422)

        expect(last_response.body)
          .to be_json_eql('password'.to_json)
                .at_path('_embedded/details/attribute')

        expect(last_response.body)
          .to be_json_eql('urn:openproject-org:api:v3:errors:PropertyIsReadOnly'.to_json)
                .at_path('errorIdentifier')
      end
    end
  end

  describe 'unauthorized user' do
    let(:current_user) { FactoryBot.build(:user) }
    let(:parameters) { { email: 'new@example.org' } }

    it 'returns an erroneous response' do
      send_request
      expect(last_response.status).to eq(403)
    end
  end
end
