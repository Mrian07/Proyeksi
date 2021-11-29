#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::ProjectStatusFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :project_status_code }
    let(:type) { :list_optional }
    let(:model) { Project }
    let(:attribute) { :project_status_code }
    let(:values) { ['On track'] }
    let(:human_name) { 'Project status' }
    let(:admin) { FactoryBot.build_stubbed(:admin) }
    let(:user) { FactoryBot.build_stubbed(:user) }

    describe '#allowed_values' do
      it 'is a list of the possible values' do
        expect(instance.allowed_values).to match_array([["At risk", "1"], ["Off track", "2"], ["On track", "0"]])
      end
    end
  end
end
