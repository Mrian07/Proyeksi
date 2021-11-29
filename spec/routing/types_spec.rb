

require 'spec_helper'

describe 'types routes', type: :routing do
  it do
    expect(post('/types/move/123')).to route_to(controller: 'types',
                                                action: 'move',
                                                id: '123')
  end
end
