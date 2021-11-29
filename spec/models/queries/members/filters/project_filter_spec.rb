#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::ProjectFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :project_id }
    let(:type) { :list_optional }
  end

  it_behaves_like 'list_optional query filter' do
    let(:attribute) { :project_id }
    let(:model) { Member }
    let(:valid_values) { ['1'] }
  end
end
