

require 'spec_helper'

describe Queries::WorkPackages::Filter::BlockedFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :blocked }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :blocked_by }
    end
  end
end
