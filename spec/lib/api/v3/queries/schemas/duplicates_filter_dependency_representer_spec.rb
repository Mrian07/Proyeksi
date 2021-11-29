

require 'spec_helper'
5
describe ::API::V3::Queries::Schemas::DuplicatesFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::DuplicatesFilter.create!(context: query) }
  end
end
