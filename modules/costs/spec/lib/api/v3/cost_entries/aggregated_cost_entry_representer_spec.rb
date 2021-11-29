

require 'spec_helper'

describe ::API::V3::CostEntries::AggregatedCostEntryRepresenter do
  include API::V3::Utilities::PathHelper

  let(:cost_entry) { FactoryBot.build_stubbed(:cost_entry) }
  let(:representer) { described_class.new(cost_entry.cost_type, cost_entry.units) }

  subject { representer.to_json }

  it 'has a type' do
    is_expected.to be_json_eql('AggregatedCostEntry'.to_json).at_path('_type')
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'costType' }
    let(:href) { api_v3_paths.cost_type cost_entry.cost_type.id }
    let(:title) { cost_entry.cost_type.name }
  end

  it 'has spent units' do
    is_expected.to be_json_eql(cost_entry.units.to_json).at_path('spentUnits')
  end
end
