

require 'spec_helper'

describe Queries::WorkPackages::Filter::BlocksFilter, type: :model do
  it_behaves_like 'filter by work package id' do
    let(:class_key) { :blocks }

    it_behaves_like 'filter for relation' do
      let(:relation_type) { class_key }
    end
  end
end
