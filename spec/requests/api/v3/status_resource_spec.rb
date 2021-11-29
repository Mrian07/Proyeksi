

require 'spec_helper'
require 'rack/test'

describe 'API v3 Status resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:role) { FactoryBot.create(:role, permissions: [:view_work_packages]) }
  let(:project) { FactoryBot.create(:project, public: false) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end

  let!(:statuses) { FactoryBot.create_list(:status, 4) }

  describe 'statuses' do
    describe '#get' do
      let(:get_path) { api_v3_paths.statuses }
      subject(:response) { last_response }

      context 'logged in user' do
        before do
          allow(User).to receive(:current).and_return current_user

          get get_path
        end

        it_behaves_like 'API V3 collection response', 4, 4, 'Status'
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

  describe 'statuses/:id' do
    describe '#get' do
      let(:status) { statuses.first }
      let(:get_path) { api_v3_paths.status status.id }

      subject(:response) { last_response }

      context 'logged in user' do
        before do
          allow(User).to receive(:current).and_return(current_user)

          get get_path
        end

        context 'valid status id' do
          it { expect(response.status).to eq(200) }
        end

        context 'invalid status id' do
          let(:get_path) { api_v3_paths.status 'bogus' }

          it_behaves_like 'param validation error' do
            let(:id) { 'bogus' }
            let(:type) { 'Status' }
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
end
