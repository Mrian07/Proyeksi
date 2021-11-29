

require 'spec_helper'
require 'rack/test'

describe ::API::V3::TimeEntries::CreateFormAPI, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project) }
  let(:active_activity) { FactoryBot.create(:time_entry_activity) }
  let(:in_project_inactive_activity) do
    FactoryBot.create(:time_entry_activity).tap do |tea|
      TimeEntryActivitiesProject.insert(project_id: project.id, activity_id: tea.id, active: false)
    end
  end
  let(:custom_field) { FactoryBot.create(:time_entry_custom_field) }
  let(:user) do
    FactoryBot.create(:user,
                      member_in_project: project,
                      member_with_permissions: permissions)
  end
  let(:work_package) do
    FactoryBot.create(:work_package, project: project)
  end
  let(:other_user) { FactoryBot.create(:user) }
  let(:permissions) { %i[log_time view_work_packages] }

  let(:path) { api_v3_paths.create_time_entry_form }
  let(:parameters) { {} }

  before do
    login_as(user)

    post path, parameters.to_json
  end

  subject(:response) { last_response }

  describe '#POST /api/v3/time_entries/form' do
    it 'returns 200 OK' do
      expect(response.status).to eq(200)
    end

    it 'returns a form' do
      expect(response.body)
        .to be_json_eql('Form'.to_json)
        .at_path('_type')
    end

    it 'does not create a time_entry' do
      expect(TimeEntry.count)
        .to eql 0
    end

    context 'with empty parameters' do
      it 'has 4 validation errors' do
        # There are 4 validation errors instead of 3 with two duplicating each other
        expect(subject.body).to have_json_size(4).at_path('_embedded/validationErrors')
      end

      it 'has a validation error on activity' do
        expect(subject.body).to have_json_path('_embedded/validationErrors/activity')
      end

      it 'has a validation error on project' do
        expect(subject.body).to have_json_path('_embedded/validationErrors/project')
      end

      it 'has a validation error on spentOn' do
        expect(subject.body).to have_json_path('_embedded/validationErrors/spentOn')
      end

      it 'has a validation error on hours' do
        expect(subject.body).to have_json_path('_embedded/validationErrors/hours')
      end

      it 'has no commit link' do
        expect(subject.body)
          .not_to have_json_path('_links/commit')
      end
    end

    context 'with all parameters' do
      let(:parameters) do
        {
          _links: {
            workPackage: {
              href: api_v3_paths.work_package(work_package.id)
            },
            project: {
              href: api_v3_paths.project(project.id)
            },
            activity: {
              href: api_v3_paths.time_entries_activity(active_activity.id)
            }
          },
          spentOn: Date.today.to_s,
          hours: 'PT5H',
          "comment": {
            raw: "some comment"
          },
          "customField#{custom_field.id}": {
            raw: 'some cf text'
          }
        }
      end

      it 'has 0 validation errors' do
        expect(subject.body).to have_json_size(0).at_path('_embedded/validationErrors')
      end

      it 'has the values prefilled in the payload' do
        body = subject.body

        expect(body)
          .to be_json_eql(api_v3_paths.project(project.id).to_json)
          .at_path('_embedded/payload/_links/project/href')

        expect(body)
          .to be_json_eql(api_v3_paths.work_package(work_package.id).to_json)
          .at_path('_embedded/payload/_links/workPackage/href')

        expect(body)
          .to be_json_eql(api_v3_paths.time_entries_activity(active_activity.id).to_json)
          .at_path('_embedded/payload/_links/activity/href')

        expect(body)
          .to be_json_eql("some comment".to_json)
          .at_path("_embedded/payload/comment/raw")

        expect(body)
          .to be_json_eql(Date.today.to_s.to_json)
          .at_path('_embedded/payload/spentOn')

        expect(body)
          .to be_json_eql("PT5H".to_json)
          .at_path('_embedded/payload/hours')

        expect(body)
          .to be_json_eql("some cf text".to_json)
          .at_path("_embedded/payload/customField#{custom_field.id}/raw")

        # As the user is always the current user, it is not part of the payload
        expect(body)
          .not_to have_json_path('_embedded/payload/_links/user')
      end

      it 'has the available values listed in the schema' do
        body = subject.body

        wp_path = api_v3_paths.time_entries_available_work_packages_on_create

        expect(body)
          .to be_json_eql(wp_path.to_json)
          .at_path('_embedded/schema/workPackage/_links/allowedValues/href')

        expect(body)
          .to be_json_eql(api_v3_paths.time_entries_available_projects.to_json)
          .at_path('_embedded/schema/project/_links/allowedValues/href')
      end

      it 'has a commit link' do
        expect(subject.body)
          .to be_json_eql(api_v3_paths.time_entries.to_json)
          .at_path('_links/commit/href')
      end
    end

    context 'without the necessary permission' do
      let(:permissions) { [] }

      it 'returns 403 Not Authorized' do
        expect(response.status).to eq(403)
      end
    end
  end
end
