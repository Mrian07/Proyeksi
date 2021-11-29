

require 'spec_helper'
require 'rack/test'

describe ::API::V3::Projects::CreateFormAPI, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  subject(:response) { last_response }

  current_user do
    FactoryBot.create(:user).tap do |u|
      FactoryBot.create(:global_member,
                        principal: u,
                        roles: [global_role])
    end
  end

  let(:global_role) do
    FactoryBot.create(:global_role, permissions: permissions)
  end
  let(:text_custom_field) do
    FactoryBot.create(:text_project_custom_field)
  end
  let(:list_custom_field) do
    FactoryBot.create(:list_project_custom_field)
  end
  let(:permissions) { [:add_project] }
  let(:path) { api_v3_paths.create_project_form }
  let(:params) do
    {
    }
  end

  before do
    post path, params.to_json
  end

  describe '#POST /api/v3/projects/form' do
    it 'returns 200 OK' do
      expect(response.status).to eq(200)
    end

    it 'returns a form' do
      expect(response.body)
        .to be_json_eql('Form'.to_json)
        .at_path('_type')
    end

    it 'does not create a project' do
      expect(Project.count)
        .to eql 0
    end

    context 'with empty parameters' do
      it 'has one validation error for name', :aggregate_failures do
        expect(subject.body).to have_json_size(1).at_path('_embedded/validationErrors')
        expect(subject.body).to have_json_path('_embedded/validationErrors/name')
        expect(subject.body).not_to have_json_path('_links/commit')
      end
    end

    context 'with all parameters' do
      let(:params) do
        {
          identifier: 'new_project_identifier',
          name: 'Project name',
          "customField#{text_custom_field.id}": {
            "raw": "CF text"
          },
          statusExplanation: { raw: "A magic dwells in each beginning." },
          "_links": {
            "customField#{list_custom_field.id}": {
              "href": api_v3_paths.custom_option(list_custom_field.custom_options.first.id)
            },
            "status": {
              "href": api_v3_paths.project_status('on_track')
            }
          }
        }
      end

      it 'has 0 validation errors' do
        expect(subject.body).to have_json_size(0).at_path('_embedded/validationErrors')
      end

      it 'has the values prefilled in the payload' do
        body = subject.body

        expect(body)
          .to be_json_eql('new_project_identifier'.to_json)
          .at_path('_embedded/payload/identifier')

        expect(body)
          .to be_json_eql('Project name'.to_json)
          .at_path('_embedded/payload/name')

        expect(body)
          .to be_json_eql('CF text'.to_json)
          .at_path("_embedded/payload/customField#{text_custom_field.id}/raw")

        expect(body)
          .to be_json_eql(api_v3_paths.custom_option(list_custom_field.custom_options.first.id).to_json)
          .at_path("_embedded/payload/_links/customField#{list_custom_field.id}/href")

        expect(body)
          .to be_json_eql(api_v3_paths.project_status('on_track').to_json)
          .at_path('_embedded/payload/_links/status/href')

        expect(body)
          .to be_json_eql(
            {
              "format": "markdown",
              "html": "<p class=\"op-uc-p\">A magic dwells in each beginning.</p>",
              "raw": "A magic dwells in each beginning."
            }.to_json
          ).at_path("_embedded/payload/statusExplanation")
      end

      it 'has a commit link' do
        expect(subject.body)
          .to be_json_eql(api_v3_paths.projects.to_json)
          .at_path('_links/commit/href')
      end
    end

    context 'with faulty status parameters' do
      let(:params) do
        {
          identifier: 'new_project_identifier',
          name: 'Project name',
          _links: {
            status: {
              href: api_v3_paths.project_status("bogus")
            }
          }
        }
      end

      it 'has 1 validation errors' do
        expect(subject.body).to have_json_size(1).at_path('_embedded/validationErrors')
      end

      it 'has a validation error on status' do
        expect(subject.body).to have_json_path('_embedded/validationErrors/status')
      end

      it 'has no commit link' do
        expect(subject.body)
          .not_to have_json_path('_links/commit')
      end
    end

    context 'with only add_subprojects permission' do
      current_user do
        FactoryBot.create(:user,
                          member_in_project: parent_project,
                          member_with_permissions: %i[add_subprojects])
      end

      let(:parent_project) { FactoryBot.create(:project) }

      let(:params) do
        {
          "_links": {
            "parent": {
              "href": api_v3_paths.project(parent_project.id)
            }
          }
        }
      end

      it 'returns 200 OK' do
        expect(response.status).to eq(200)
      end

      it 'returns the schema with a required parent field' do
        expect(response.body)
          .to be_json_eql(true)
                .at_path('_embedded/schema/parent/required')
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
