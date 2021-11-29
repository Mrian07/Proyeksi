

require 'spec_helper'

describe ::API::V3::Queries::Schemas::FollowsFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::FollowsFilter.create!(context: query) }
  end
end
