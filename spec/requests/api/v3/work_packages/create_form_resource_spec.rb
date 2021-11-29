

require 'spec_helper'
require 'rack/test'

describe ::API::V3::WorkPackages::CreateProjectFormAPI do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  shared_let(:status) { FactoryBot.create(:default_status) }
  shared_let(:priority) { FactoryBot.create(:default_priority) }
  shared_let(:user) { FactoryBot.create(:admin) }
  shared_let(:project) { FactoryBot.create(:project_with_types) }

  let(:path) { api_v3_paths.create_work_package_form }
  let(:parameters) { {} }

  before do
    login_as(user)
    post path, parameters.to_json, 'CONTENT_TYPE' => 'application/json'
  end

  subject(:response) { last_response }

  it 'should return 200(OK)' do
    expect(response.status).to eq(200)
  end

  it 'should be of type form' do
    expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')
  end

  it 'has the available_projects link for creation in the schema' do
    expect(response.body)
      .to be_json_eql(api_v3_paths.available_projects_on_create(nil).to_json)
      .at_path('_embedded/schema/project/_links/allowedValues/href')
  end

  describe 'with empty parameters' do
    it 'has 3 validation errors' do
      expect(subject.body).to have_json_size(3).at_path('_embedded/validationErrors')
    end

    it 'has a validation error on subject' do
      expect(subject.body).to have_json_path('_embedded/validationErrors/subject')
    end

    it 'has a validation error on type' do
      expect(subject.body).to have_json_path('_embedded/validationErrors/type')
    end

    it 'has a validation error on project' do
      expect(subject.body).to have_json_path('_embedded/validationErrors/project')
    end
  end

  describe 'with all minimum parameters' do
    let(:type) { project.types.first }
    let(:parameters) do
      {
        _links: {
          project: {
            href: "/api/v3/projects/#{project.id}"
          }
        },
        subject: 'lorem ipsum'
      }
    end

    it 'has 0 validation errors' do
      expect(subject.body).to have_json_size(0).at_path('_embedded/validationErrors')
    end

    it 'has the default type active in the project set' do
      type_link = {
        href: "/api/v3/types/#{type.id}",
        title: type.name
      }

      expect(subject.body)
        .to be_json_eql(type_link.to_json)
        .at_path('_embedded/payload/_links/type')
    end
  end
end
