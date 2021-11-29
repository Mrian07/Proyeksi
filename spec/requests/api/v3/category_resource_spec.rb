

require 'spec_helper'
require 'rack/test'

describe 'API v3 Category resource' do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:role) { FactoryBot.create(:role, permissions: []) }
  let(:private_project) { FactoryBot.create(:project, public: false) }
  let(:public_project) { FactoryBot.create(:project, public: true) }
  let(:anonymous_user) { FactoryBot.create(:user) }
  let(:privileged_user) do
    FactoryBot.create(:user,
                      member_in_project: private_project,
                      member_through_role: role)
  end

  let!(:categories) { FactoryBot.create_list(:category, 3, project: private_project) }
  let!(:other_categories) { FactoryBot.create_list(:category, 2, project: public_project) }
  let!(:user_categories) do
    FactoryBot.create_list(:category,
                           2,
                           project: private_project,
                           assigned_to: privileged_user)
  end

  describe 'categories by project' do
    subject(:response) { last_response }

    context 'logged in user' do
      let(:get_path) { api_v3_paths.categories_by_project private_project.id }
      before do
        allow(User).to receive(:current).and_return privileged_user

        get get_path
      end

      it_behaves_like 'API V3 collection response', 5, 5, 'Category'
    end

    context 'not logged in user' do
      let(:get_path) { api_v3_paths.categories_by_project private_project.id }
      before do
        allow(User).to receive(:current).and_return anonymous_user

        get get_path
      end

      it_behaves_like 'not found'
    end
  end

  describe 'categories/:id' do
    subject(:response) { last_response }

    context 'logged in user' do
      let(:get_path) { api_v3_paths.category categories.first.id }
      before do
        allow(User).to receive(:current).and_return privileged_user

        get get_path
      end

      context 'valid priority id' do
        it 'should return HTTP 200' do
          expect(response.status).to eql(200)
        end
      end

      context 'invalid priority id' do
        let(:get_path) { api_v3_paths.category 'bogus' }
        it_behaves_like 'param validation error' do
          let(:id) { 'bogus' }
          let(:type) { 'Category' }
        end
      end
    end

    context 'not logged in user' do
      let(:get_path) { api_v3_paths.category 'bogus' }
      before do
        allow(User).to receive(:current).and_return anonymous_user

        get get_path
      end

      it_behaves_like 'param validation error' do
        let(:id) { 'bogus' }
        let(:type) { 'Category' }
      end
    end
  end
end
