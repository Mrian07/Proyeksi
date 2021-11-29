

require 'spec_helper'

describe SearchController, type: :routing do
  it 'should connect GET /search to search#index' do
    expect(get('/search')).to route_to(controller: 'search',
                                       action: 'index')
  end
end
