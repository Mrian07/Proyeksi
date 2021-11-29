

require 'spec_helper'
require 'rack/test'

describe 'API v3 Budget resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project, public: false) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: [:view_budgets])
  end
  subject(:response) { last_response }

  let!(:budget) { FactoryBot.create(:budget, project: project) }

  describe 'budgets/:id' do
    let(:get_path) { api_v3_paths.budget budget.id }

    context 'logged in user' do
      before do
        allow(User).to receive(:current).and_return current_user

        get get_path
      end

      context 'valid id' do
        it 'should return HTTP 200' do
          expect(response.status).to eql(200)
        end
      end

      context 'invalid id' do
        let(:get_path) { api_v3_paths.budget 'bogus' }

        it_behaves_like 'param validation error' do
          let(:id) { 'bogus' }
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

  describe 'projects/:id/budgets' do
    let(:get_path) { api_v3_paths.budgets_by_project project.id }

    context 'logged in user' do
      before do
        allow(User).to receive(:current).and_return current_user

        get get_path
      end

      it 'should return HTTP 200' do
        expect(response.status).to eql(200)
      end
    end

    context 'not logged in user' do
      before do
        get get_path
      end

      it_behaves_like 'not found'
    end
  end
end
