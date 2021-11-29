#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Capabilities::Filters::PrincipalIdFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :principal_id }
    let(:type) { :integer }
    let(:model) { Capability }
    let(:attribute) { :principal_id }
    let(:values) { ['5'] }
  end
end
