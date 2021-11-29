

require 'spec_helper'
5
describe ::API::V3::Queries::Schemas::IncludesFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::IncludesFilter.create!(context: query) }
  end
end
