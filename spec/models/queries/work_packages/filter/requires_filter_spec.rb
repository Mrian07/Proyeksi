

require 'spec_helper'

describe Queries::WorkPackages::Filter::RequiresFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :requires }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :requires }
    end
  end
end
