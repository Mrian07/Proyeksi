

require 'spec_helper'

describe 'homescreen routes', type: :routing do
  it '/ routes to homscreen#index' do
    expect(get('/')).to route_to('homescreen#index')
  end
end
