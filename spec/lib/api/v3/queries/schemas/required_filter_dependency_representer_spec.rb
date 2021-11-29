

require 'spec_helper'
5
describe ::API::V3::Queries::Schemas::RequiredFilterDependencyRepresenter, clear_cache: true do
  it_behaves_like 'relation filter dependency' do
    let(:filter) { Queries::WorkPackages::Filter::RequiredFilter.create!(context: query) }
  end
end
