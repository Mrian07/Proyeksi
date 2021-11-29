

require 'spec_helper'

describe "API::V3::Projects::AvailableAssigneesAPI", type: :request do
  include API::V3::Utilities::PathHelper

  it_behaves_like 'available principals', :assignees do
    let(:href) { api_v3_paths.available_assignees(project.id) }
  end
end
