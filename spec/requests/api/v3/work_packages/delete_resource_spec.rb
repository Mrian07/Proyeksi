

require 'spec_helper'
require 'rack/test'

describe 'API v3 Work package resource',
         type: :request,
         content_type: :json do
  include API::V3::Utilities::PathHelper

  let(:work_package) do
    FactoryBot.create(:work_package,
                      project_id: project.id,
                      description: 'lorem ipsum')
  end
  let(:project) do
    FactoryBot.create(:project, identifier: 'test_project', public: false)
  end
  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i[view_work_packages edit_work_packages assign_versions] }

  current_user do
    user = FactoryBot.create(:user, member_in_project: project, member_through_role: role)

    FactoryBot.create(:user_preference, user: user)

    user
  end

  describe 'DELETE /api/v3/work_packages/:id' do
    subject { last_response }

    let(:path) { api_v3_paths.work_package work_package.id }

    before do
      delete path
    end

    context 'with required permissions' do
      let(:permissions) { %i[view_work_packages delete_work_packages] }

      it 'responds with HTTP No Content' do
        expect(subject.status).to eq 204
      end

      it 'deletes the work package' do
        expect(WorkPackage.exists?(work_package.id)).to be_falsey
      end

      context 'for a non-existent work package' do
        let(:path) { api_v3_paths.work_package 1337 }

        it_behaves_like 'not found',
                        I18n.t('api_v3.errors.not_found.work_package')
      end
    end

    context 'without permission to see work packages' do
      let(:permissions) { [] }

      it_behaves_like 'not found',
                      I18n.t('api_v3.errors.not_found.work_package')
    end

    context 'without permission to delete work packages' do
      let(:permissions) { [:view_work_packages] }

      it_behaves_like 'unauthorized access'

      it 'does not delete the work package' do
        expect(WorkPackage.exists?(work_package.id)).to be_truthy
      end
    end
  end
end
