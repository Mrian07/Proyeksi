

require 'spec_helper'

describe Queries::WorkPackages::Filter::IncludesFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :includes }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :includes }
    end
  end
end
