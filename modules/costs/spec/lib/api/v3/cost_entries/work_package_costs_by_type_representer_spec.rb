

require 'spec_helper'

describe ::API::V3::CostEntries::WorkPackageCostsByTypeRepresenter do
  include API::V3::Utilities::PathHelper

  let(:project) { FactoryBot.create(:project) }
  let(:work_package) { FactoryBot.create(:work_package, project: project) }
  let(:cost_type_A) { FactoryBot.create(:cost_type) }
  let(:cost_type_B) { FactoryBot.create(:cost_type) }
  let(:cost_entries_A) do
    FactoryBot.create_list(:cost_entry,
                           2,
                           units: 1,
                           work_package: work_package,
                           project: project,
                           cost_type: cost_type_A)
  end
  let(:cost_entries_B) do
    FactoryBot.create_list(:cost_entry,
                           3,
                           units: 2,
                           work_package: work_package,
                           project: project,
                           cost_type: cost_type_B)
  end
  let(:current_user) do
    FactoryBot.create(:user, member_in_project: project, member_through_role: role)
  end
  let(:role) { FactoryBot.build(:role, permissions: [:view_cost_entries]) }

  let(:representer) { described_class.new(work_package, current_user: current_user) }

  subject { representer.to_json }

  before do
    # create the lists
    cost_entries_A
    cost_entries_B
  end

  it 'has a type' do
    is_expected.to be_json_eql('Collection'.to_json).at_path('_type')
  end

  it 'has one element per type' do
    is_expected.to have_json_size(2).at_path('_embedded/elements')
  end

  it 'indicates the cost types' do
    elements = JSON.parse(subject)['_embedded']['elements']
    types = elements.map { |entry| entry['_links']['costType']['href'] }
    expect(types).to include(api_v3_paths.cost_type(cost_type_A.id))
    expect(types).to include(api_v3_paths.cost_type(cost_type_B.id))
  end

  it 'aggregates the units' do
    elements = JSON.parse(subject)['_embedded']['elements']
    units_by_type = elements.inject({}) do |hash, entry|
      hash[entry['_links']['costType']['href']] = entry['spentUnits']
      hash
    end

    expect(units_by_type[api_v3_paths.cost_type cost_type_A.id]).to eql 2.0
    expect(units_by_type[api_v3_paths.cost_type cost_type_B.id]).to eql 6.0
  end
end
