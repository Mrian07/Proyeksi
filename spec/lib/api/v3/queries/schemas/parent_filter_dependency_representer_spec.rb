

require 'spec_helper'

describe ::API::V3::Queries::Schemas::ParentFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::ParentFilter.create!(context: query) }
  end
end
