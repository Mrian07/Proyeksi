

require 'spec_helper'
require 'rack/test'

describe 'API v3 Project status resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  current_user { FactoryBot.create(:user) }

  describe '#get /project_statuses/:id' do
    subject(:response) do
      get get_path

      last_response
    end

    let(:status) { Projects::Status.codes.keys.last }
    let(:get_path) { api_v3_paths.project_status status }

    context 'logged in user' do
      it 'responds with 200 OK' do
        expect(subject.status).to eq(200)
      end

      it 'responds with the correct project' do
        expect(subject.body)
          .to be_json_eql('ProjectStatus'.to_json)
                .at_path('_type')
        expect(subject.body)
          .to be_json_eql(status.to_json)
                .at_path('id')
      end

      context 'requesting nonexistent status' do
        let(:status) { 'bogus' }

        before do
          response
        end

        it_behaves_like 'not found'
      end
    end
  end
end
