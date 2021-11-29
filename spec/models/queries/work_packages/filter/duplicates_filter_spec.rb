

require 'spec_helper'

describe Queries::WorkPackages::Filter::DuplicatesFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :duplicates }

    it_behaves_like 'filter for relation' do
      # WP filter forward id duplicated, backwards is duplicates!
      # 1 -- duplicates --> 2
      # then to_id: 2, type :duplicated
      let(:relation_type) { :duplicated }
    end
  end
end
