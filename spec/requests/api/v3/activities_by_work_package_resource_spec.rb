

require 'spec_helper'
require 'rack/test'

describe API::V3::Activities::ActivitiesByWorkPackageAPI, type: :request do
  include API::V3::Utilities::PathHelper

  describe 'activities' do
    let(:project) { work_package.project }
    let(:work_package) { FactoryBot.create(:work_package) }
    let(:comment) { 'This is a test comment!' }
    let(:current_user) do
      FactoryBot.create(:user, member_in_project: project, member_through_role: role)
    end
    let(:role) { FactoryBot.create(:role, permissions: permissions) }
    let(:permissions) { %i(view_work_packages add_work_package_notes) }

    before do
      allow(User).to receive(:current).and_return(current_user)
    end

    describe 'GET /api/v3/work_packages/:id/activities' do
      before do
        get api_v3_paths.work_package_activities work_package.id
      end

      it 'succeeds' do
        expect(last_response.status).to eql 200
      end

      context 'not allowed to see work package' do
        let(:current_user) { FactoryBot.create(:user) }

        it 'fails with HTTP Not Found' do
          expect(last_response.status).to eql 404
        end
      end
    end

    describe 'POST /api/v3/work_packages/:id/activities' do
      let(:work_package) { FactoryBot.create(:work_package) }

      shared_context 'create activity' do
        before do
          header "Content-Type", "application/json"
          post api_v3_paths.work_package_activities(work_package.id),
               { comment: { raw: comment } }.to_json
        end
      end

      it_behaves_like 'safeguarded API' do
        let(:permissions) { %i(view_work_packages) }

        include_context 'create activity'
      end

      it_behaves_like 'valid activity request' do
        let(:status_code) { 201 }

        include_context 'create activity'
      end

      context 'with an errorenous work package' do
        before do
          work_package.subject = ''
          work_package.save!(validate: false)
        end

        include_context 'create activity'

        it 'responds with error' do
          expect(last_response.status).to eql 422
        end

        it 'notes the error' do
          expect(last_response.body)
            .to be_json_eql("Subject can't be blank.".to_json)
            .at_path('message')
        end
      end
    end
  end
end
