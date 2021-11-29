#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Notifications::Filters::IdFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :id }
    let(:type) { :list }
    let(:model) { Notification }
    let(:attribute) { :id }
    let(:values) { ['5'] }
  end
end
