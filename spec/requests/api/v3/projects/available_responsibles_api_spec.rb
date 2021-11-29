

require 'spec_helper'

describe "API::V3::Projects::AvailableResponsiblesAPI", type: :request do
  include API::V3::Utilities::PathHelper

  it_behaves_like 'available principals', :responsibles do
    let(:href) { api_v3_paths.available_responsibles(project.id) }
  end
end
