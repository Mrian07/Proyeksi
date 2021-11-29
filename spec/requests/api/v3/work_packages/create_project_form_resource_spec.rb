

require 'spec_helper'
require 'rack/test'

describe ::API::V3::WorkPackages::CreateProjectFormAPI, content_type: :json do
  include Rack::Test::Methods
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project, id: 5) }
  let(:post_path) { api_v3_paths.create_project_work_package_form(project.id) }
  let(:user) { FactoryBot.build(:admin) }

  before do
    login_as(user)
    post post_path
  end

  subject(:response) { last_response }

  it 'should return 200(OK)' do
    expect(response.status).to eq(200)
  end

  it 'should be of type form' do
    expect(response.body).to be_json_eql('Form'.to_json).at_path('_type')
  end
end
