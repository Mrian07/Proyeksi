

require 'spec_helper'
5
describe ::API::V3::Queries::Schemas::PartofFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::PartofFilter.create!(context: query) }
  end
end
