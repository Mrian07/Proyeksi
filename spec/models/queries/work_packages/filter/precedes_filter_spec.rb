

require 'spec_helper'

describe Queries::WorkPackages::Filter::PrecedesFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :precedes }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :precedes }
    end
  end
end
