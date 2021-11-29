

require 'spec_helper'
5
describe ::API::V3::Queries::Schemas::RelatesFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::RelatesFilter.create!(context: query) }
  end
end
