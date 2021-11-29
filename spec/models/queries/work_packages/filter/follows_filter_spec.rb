

require 'spec_helper'

describe Queries::WorkPackages::Filter::FollowsFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :follows }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :follows }
    end
  end
end
