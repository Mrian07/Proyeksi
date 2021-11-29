

require 'spec_helper'

shared_examples_for 'API V3 digest' do
  it 'defines an algorithm' do
    is_expected.to be_json_eql(algorithm.to_json).at_path("#{path}/algorithm")
  end

  it 'has a hash' do
    is_expected.to be_json_eql(hash.to_json).at_path("#{path}/hash")
  end
end
