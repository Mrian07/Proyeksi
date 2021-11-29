

require 'spec_helper'
require 'rack/test'

describe 'API v3 Type resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:role) { FactoryBot.create(:role, permissions: [:view_work_packages]) }
  let(:project) { FactoryBot.create(:project, no_types: true, public: false) }
  let(:current_user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end

  let!(:types) { FactoryBot.create_list(:type, 4) }

  describe 'types' do
    describe '#get' do
      let(:get_path) { api_v3_paths.types }
      subject(:response) { last_response }

      context 'logged in user' do
        before do
          allow(User).to receive(:current).and_return current_user

          get get_path
        end

        it_behaves_like 'API V3 collection response', 4, 4, 'Type'
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

  describe 'types/:id' do
    describe '#get' do
      let(:type) { types.first }
      let(:get_path) { api_v3_paths.type type.id }

      subject(:response) { last_response }

      context 'logged in user' do
        before do
          allow(User).to receive(:current).and_return(current_user)

          get get_path
        end

        context 'valid type id' do
          it { expect(response.status).to eq(200) }
        end

        context 'invalid type id' do
          let(:get_path) { api_v3_paths.type 'bogus' }

          it_behaves_like 'param validation error' do
            let(:id) { 'bogus' }
            let(:type) { 'Type' }
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
