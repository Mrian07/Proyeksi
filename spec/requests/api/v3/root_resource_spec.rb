

require 'spec_helper'
require 'rack/test'

describe 'API v3 Root resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:role) { FactoryBot.create(:role, permissions: []) }
  let(:project) { FactoryBot.create(:project, public: false) }

  describe '#get' do
    let(:response) { last_response }
    subject { response.body }
    let(:get_path) { api_v3_paths.root }

    context 'anonymous user' do
      before do
        get get_path
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should respond with a root representer' do
        expect(subject).to have_json_path('instanceName')
      end
    end

    context 'logged in user' do
      before do
        allow(User).to receive(:current).and_return current_user

        get get_path
      end

      it 'should respond with 200' do
        expect(response.status).to eq(200)
      end

      it 'should respond with a root representer' do
        expect(subject).to have_json_path('instanceName')
      end

      context 'without the X-requested-with header', skip_xhr_header: true do
        it 'returns OK because GET requests are allowed' do
          expect(response.status).to eq(200)
          expect(subject).to have_json_path('instanceName')
        end
      end
    end
  end
end
