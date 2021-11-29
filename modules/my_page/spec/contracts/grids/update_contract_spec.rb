#-- encoding: UTF-8



require 'spec_helper'
require_relative './shared_examples'

describe Grids::UpdateContract do
  include_context 'model contract'
  include_context 'grid contract'

  it_behaves_like 'shared grid contract attributes'
end
