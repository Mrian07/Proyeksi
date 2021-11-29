#-- encoding: UTF-8



require 'spec_helper'

describe Queries::Projects::Filters::ActiveFilter, type: :model do
  it_behaves_like 'boolean query filter' do
    let(:model) { Project }
    let(:attribute) { :active }
  end
end
