

require 'spec_helper'
require 'rack/test'

describe 'API v3 Work package resource', type: :request, content_type: :json do
  include Rack::Test::Methods
  include Capybara::RSpecMatchers
  include API::V3::Utilities::PathHelper

  let(:work_package) do
    FactoryBot.create(
      :work_package,
      project_id: project.id,
      parent: parent,
      subject: "Updated WorkPackage"
    )
  end

  let!(:parent) do
    FactoryBot.create(:work_package, project_id: project.id, type: type, subject: "Invalid Dependent WorkPackage").tap do |parent|
      parent.custom_values.create custom_field: custom_field, value: custom_field.possible_values.first.id

      cv = parent.custom_values.last
      cv.update_column :value, "0"
    end
  end

  let(:project) do
    FactoryBot.create(:project, identifier: 'deperr', public: false).tap do |project|
      project.types << type
    end
  end

  let(:type) do
    FactoryBot.create(:type).tap do |type|
      type.custom_fields << custom_field
    end
  end

  let(:status) { FactoryBot.create :status }

  let(:custom_field) do
    FactoryBot.create(
      :list_wp_custom_field,
      name: "Gate",
      possible_values: %w(A B C),
      is_required: true
    )
  end

  let(:role) { FactoryBot.create(:role, permissions: permissions) }
  let(:permissions) { %i[view_work_packages edit_work_packages create_work_packages] }

  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end

  let(:dependent_error_result) do
    proc do |instance, _attributes, work_package|
      result = ServiceResult.new(success: true, result: instance.respond_to?(:model) && instance.model || work_package)
      dep = parent
      dep.errors.add :base, "invalid", message: "invalid"

      result.add_dependent!(ServiceResult.new(success: false, errors: dep.errors, result: dep))

      result
    end
  end

  before do
    login_as current_user
  end

  describe '#patch' do
    let(:path) { api_v3_paths.work_package work_package.id }
    let(:valid_params) do
      {
        _type: 'WorkPackage',
        lockVersion: work_package.lock_version
      }
    end

    subject(:response) { last_response }

    shared_context 'patch request' do
      before(:each) do
        patch path, params.to_json, 'CONTENT_TYPE' => 'application/json'
      end
    end

    before do
      allow_any_instance_of(WorkPackages::UpdateService).to receive(:update_dependent, &dependent_error_result)
    end

    context 'attribute' do
      let(:params) { valid_params.merge(startDate: "2018-05-23") }

      include_context 'patch request'

      it { expect(response.status).to eq(422) }

      it 'should respond with an error' do
        expected_error = {
          "_type": "Error",
          "errorIdentifier": "urn:proyeksiapp-org:api:v3:errors:PropertyConstraintViolation",
          "message": "Error attempting to alter dependent object: Work package ##{parent.id} - #{parent.subject}: invalid",
          "_embedded": {
            "details": {
              "attribute": "base"
            }
          }
        }

        expect(subject.body).to be_json_eql(expected_error.to_json)
      end
    end
  end

  describe '#post' do
    let(:current_user) { FactoryBot.create :admin }

    let(:path) { api_v3_paths.work_packages }
    let(:valid_params) do
      {
        _type: 'WorkPackage',
        lockVersion: 0,
        _links: {
          author: { href: "/api/v3/users/#{current_user.id}" },
          project: { href: "/api/v3/projects/#{project.id}" },
          status: { href: "/api/v3/statuses/#{status.id}" },
          priority: { href: "/api/v3/priorities/#{work_package.priority.id}" }
        }
      }
    end

    subject(:response) { last_response }

    shared_context 'post request' do
      before(:each) do
        post path, params.to_json, 'CONTENT_TYPE' => 'application/json'
      end
    end

    before do
      allow_any_instance_of(WorkPackages::CreateService).to receive(:create, &dependent_error_result)
    end

    context 'request' do
      let(:params) { valid_params.merge(subject: "Test Subject") }

      include_context 'post request'

      it { expect(response.status).to eq(422) }

      it 'should respond with an error' do
        expected_error = {
          "_type": "Error",
          "errorIdentifier": "urn:proyeksiapp-org:api:v3:errors:PropertyConstraintViolation",
          "message": "Error attempting to alter dependent object: Work package ##{parent.id} - #{parent.subject}: invalid",
          "_embedded": {
            "details": {
              "attribute": "base"
            }
          }
        }

        expect(subject.body).to be_json_eql(expected_error.to_json)
      end
    end
  end
end
