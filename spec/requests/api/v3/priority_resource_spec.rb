

require 'spec_helper'
require 'rack/test'

describe 'API v3 Priority resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:role) { FactoryBot.create(:role, permissions: [:view_work_packages]) }
  let(:project) { FactoryBot.create(:project, public: false) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end

  let!(:priorities) { FactoryBot.create_list(:priority, 2) }

  describe 'priorities' do
    subject(:response) { last_response }

    let(:get_path) { api_v3_paths.priorities }

    context 'logged in user' do
      before do
        allow(User).to receive(:current).and_return current_user

        get get_path
      end

      it_behaves_like 'API V3 collection response', 2, 2, 'Priority'
    end

    context 'not logged in user' do
      before do
        get get_path
      end

      it_behaves_like 'error response',
                      403,
                      'MissingPermission',
                      I18n.t('api_v3.errors.code_403')
    end
  end

  describe 'priorities/:id' do
    subject(:response) { last_response }

    let(:get_path) { api_v3_paths.priority priorities.first.id }

    context 'logged in user' do
      before do
        allow(User).to receive(:current).and_return current_user

        get get_path
      end

      context 'valid priority id' do
        it 'should return HTTP 200' do
          expect(response.status).to eql(200)
        end
      end

      context 'invalid priority id' do
        let(:get_path) { api_v3_paths.priority 'bogus' }

        it_behaves_like 'param validation error' do
          let(:id) { 'bogus' }
          let(:type) { 'IssuePriority' }
        end
      end
    end

    context 'not logged in user' do
      before do
        get get_path
      end

      it_behaves_like 'error response',
                      403,
                      'MissingPermission',
                      I18n.t('api_v3.errors.code_403')
    end
  end
end
