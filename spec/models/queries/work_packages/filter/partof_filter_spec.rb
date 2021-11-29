

require 'spec_helper'

describe Queries::WorkPackages::Filter::PartofFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :partof }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :part_of }
    end
  end
end
