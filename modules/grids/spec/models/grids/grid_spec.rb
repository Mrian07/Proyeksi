

require 'spec_helper'
require_relative './shared_model'

describe Grids::Grid, type: :model do
  let(:instance) { Grids::Grid.new column_count: 5, row_count: 5 }

  it_behaves_like 'grid attributes'
end
