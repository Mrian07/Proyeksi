#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Members::Filters::UpdatedAtFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :updated_at }
    let(:type) { :datetime_past }
    let(:model) { Member }
    let(:attribute) { :updated_at }
    let(:values) { ['3'] }
  end
end
