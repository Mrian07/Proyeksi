

require 'spec_helper'

describe Queries::WorkPackages::Filter::RelatesFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :relates }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :related_to }
    end
  end
end
