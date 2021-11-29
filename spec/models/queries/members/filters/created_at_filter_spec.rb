#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::CreatedAtFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :created_at }
    let(:type) { :datetime_past }
    let(:model) { Member }
    let(:attribute) { :created_at }
    let(:values) { ['3'] }
  end
end
