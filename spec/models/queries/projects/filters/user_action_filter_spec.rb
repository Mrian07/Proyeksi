#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::UserActionFilter, type: :model do
  it_behaves_like 'basic query filter' do
    let(:class_key) { :user_action }
    let(:type) { :list }
    let(:model) { Project }
    let(:attribute) { :user_action }
    let(:values) { ['projects/view'] }
  end
end
