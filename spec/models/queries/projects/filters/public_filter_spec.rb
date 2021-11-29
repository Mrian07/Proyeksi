#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::PublicFilter, type: :model do
  it_behaves_like 'boolean query filter' do
    let(:model) { Project }
    let(:attribute) { :public }
  end
end
