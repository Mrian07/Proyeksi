

require 'spec_helper'
require 'rack/test'

describe 'API v3 Configuration resource', type: :request do
  include Rack::Test::Methods
  include ::API::V3::Utilities::PathHelper

  let(:user) { FactoryBot.create(:user) }
  let(:configuration_path) { api_v3_paths.configuration }
  subject(:response) { last_response }

  before do
    login_as(user)
  end

  describe '#GET' do
    before do
      get configuration_path
    end

    it 'returns 200 OK' do
      expect(subject.status).to eq(200)
    end

    it 'returns the configuration', with_settings: { per_page_options: '3, 5, 8, 13' } do
      expect(subject.body)
        .to be_json_eql('Configuration'.to_json)
        .at_path("_type")

      expect(subject.body)
        .to be_json_eql([3, 5, 8, 13].to_json)
        .at_path('perPageOptions')
    end

    it 'embedds the current user preferences' do
      expect(subject.body)
        .to be_json_eql('UserPreferences'.to_json)
        .at_path('_embedded/userPreferences/_type')
    end

    context 'for a non logged in user' do
      it 'returns 200 OK' do
        expect(subject.status).to eq(200)
      end
    end

    it 'does not embed the preferences' do
      expect(subject.body)
        .not_to have_json_path('_embedded/user_preferences')
    end
  end
end
