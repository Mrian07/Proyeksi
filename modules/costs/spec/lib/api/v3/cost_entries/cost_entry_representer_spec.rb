

require 'spec_helper'

describe ::API::V3::CostEntries::CostEntryRepresenter do
  include API::V3::Utilities::PathHelper

  let(:cost_entry) { FactoryBot.build_stubbed(:cost_entry) }
  let(:representer) { described_class.new(cost_entry, current_user: double('current_user')) }

  subject { representer.to_json }

  it 'has a type' do
    is_expected.to be_json_eql('CostEntry'.to_json).at_path('_type')
  end

  it_behaves_like 'has an untitled link' do
    let(:link) { 'self' }
    let(:href) { api_v3_paths.cost_entry cost_entry.id }
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'project' }
    let(:href) { api_v3_paths.project cost_entry.project.id }
    let(:title) { cost_entry.project.name }
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'user' }
    let(:href) { api_v3_paths.user cost_entry.user_id }
    let(:title) { cost_entry.user.name }
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'costType' }
    let(:href) { api_v3_paths.cost_type cost_entry.cost_type.id }
    let(:title) { cost_entry.cost_type.name }
  end

  it_behaves_like 'has a titled link' do
    let(:link) { 'workPackage' }
    let(:href) { api_v3_paths.work_package cost_entry.work_package.id }
    let(:title) { cost_entry.work_package.subject }
  end

  it 'has an id' do
    is_expected.to be_json_eql(cost_entry.id.to_json).at_path('id')
  end

  it 'has spent units' do
    is_expected.to be_json_eql(cost_entry.units.to_json).at_path('spentUnits')
  end

  it_behaves_like 'has ISO 8601 date only' do
    let(:date) { cost_entry.spent_on }
    let(:json_path) { 'spentOn' }
  end

  it_behaves_like 'has UTC ISO 8601 date and time' do
    let(:date) { cost_entry.created_at }
    let(:json_path) { 'createdAt' }
  end

  it_behaves_like 'has UTC ISO 8601 date and time' do
    let(:date) { cost_entry.updated_at }
    let(:json_path) { 'updatedAt' }
  end
end
