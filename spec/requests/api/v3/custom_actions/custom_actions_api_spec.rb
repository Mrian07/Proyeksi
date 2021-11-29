

require 'spec_helper'
require 'rack/test'

describe 'API::V3::CustomActions::CustomActionsAPI', type: :request do
  include API::V3::Utilities::PathHelper

  let(:role) do
    FactoryBot.create(:role,
                      permissions: %i[edit_work_packages view_work_packages])
  end
  let(:project) { FactoryBot.create(:project) }
  let(:work_package) do
    FactoryBot.create(:work_package,
                      project: project,
                      assigned_to: user)
  end
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_through_role: role)
  end
  let(:action) do
    FactoryBot.create(:custom_action, actions: [CustomActions::Actions::AssignedTo.new(nil)])
  end
  let(:parameters) do
    {
      lockVersion: work_package.lock_version,
      _links: {
        workPackage: {
          href: api_v3_paths.work_package(work_package.id)
        }
      }
    }
  end

  before do
    login_as(user)
  end

  describe 'GET api/v3/custom_actions/:id' do
    shared_context 'get request' do
      before do
        get api_v3_paths.custom_action(action.id)
      end
    end

    context 'for an existing action' do
      include_context 'get request'

      it 'is a 200 OK' do
        expect(last_response.status)
          .to eql(200)
      end
    end

    context 'for a non existing action' do
      before do
        get api_v3_paths.custom_action(0)
      end

      it 'is a 404 NOT FOUND' do
        expect(last_response.status)
          .to eql(404)
      end
    end

    context 'when lacking permissions' do
      let(:user) { FactoryBot.create(:user) }

      include_context 'get request'

      it 'is a 403 NOT AUTHORIZED' do
        expect(last_response.status)
          .to eql(403)
      end
    end
  end

  describe 'POST api/v3/custom_actions/:id/execute' do
    shared_context 'post request' do
      before do
        post api_v3_paths.custom_action_execute(action.id),
             parameters.to_json,
             'CONTENT_TYPE' => 'application/json'
      end
    end

    context 'for an existing action' do
      include_context 'post request'

      it 'is a 200 OK' do
        expect(last_response.status)
          .to eql(200)
      end

      it 'returns the altered work package' do
        expect(last_response.body)
          .to be_json_eql('WorkPackage'.to_json)
          .at_path('_type')
        expect(last_response.body)
          .to be_json_eql(nil.to_json)
          .at_path('_links/assignee/href')
        expect(last_response.body)
          .to be_json_eql(work_package.lock_version + 1)
          .at_path('lockVersion')
      end
    end

    context 'on a conflict' do
      let(:parameters) do
        {
          lockVersion: 0,
          _links: {
            workPackage: {
              href: api_v3_paths.work_package(work_package.id)
            }
          }
        }
      end

      before do
        # bump lock version
        WorkPackage.where(id: work_package.id).update_all(lock_version: 1)
      end

      include_context 'post request'

      it_behaves_like 'update conflict'
    end

    context 'without a lock version' do
      let(:parameters) do
        {
          _links: {
            workPackage: {
              href: api_v3_paths.work_package(work_package.id)
            }
          }
        }
      end

      include_context 'post request'

      it_behaves_like 'update conflict'
    end

    context 'without a work package' do
      let(:parameters) do
        {
          lockVersion: 1
        }
      end

      include_context 'post request'

      it 'returns a 422 error' do
        expect(last_response.status)
          .to eql 422
      end
    end

    context 'with a non visible work package' do
      let(:invisible_work_package) { FactoryBot.create(:work_package) }

      let(:parameters) do
        {
          lockVersion: 1,
          _links: {
            workPackage: {
              href: api_v3_paths.work_package(invisible_work_package.id)
            }
          }
        }
      end

      include_context 'post request'

      it 'returns a 422 error' do
        expect(last_response.status)
          .to eql 422
      end
    end
  end
end
