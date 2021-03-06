

require 'spec_helper'

describe ::API::V3::CostTypes::CostTypeRepresenter do
  include API::V3::Utilities::PathHelper

  let(:cost_type) { FactoryBot.build_stubbed(:cost_type) }
  let(:representer) { described_class.new(cost_type, current_user: double('current_user')) }

  subject { representer.to_json }

  it 'has a type' do
    is_expected.to be_json_eql('CostType'.to_json).at_path('_type')
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'self' }
    let(:href) { api_v3_paths.cost_type cost_type.id }
    let(:title) { cost_type.name }
  end

  it 'has an id' do
    is_expected.to be_json_eql(cost_type.id.to_json).at_path('id')
  end

  it 'has a name' do
    is_expected.to be_json_eql(cost_type.name.to_json).at_path('name')
  end

  it 'has a unit' do
    is_expected.to be_json_eql(cost_type.unit.to_json).at_path('unit')
  end

  it 'has a pluralized unit' do
    is_expected.to be_json_eql(cost_type.unit_plural.to_json).at_path('unitPlural')
  end

  it 'indicates if it is the default' do
    is_expected.to be_json_eql(cost_type.default.to_json).at_path('isDefault')
  end
end
