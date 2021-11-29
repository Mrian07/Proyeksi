

require 'spec_helper'

describe Queries::WorkPackages::Filter::RequiredFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :required }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { :required_by }
    end
  end
end
