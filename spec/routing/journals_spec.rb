

require 'spec_helper'

describe JournalsController, type: :routing do
  it 'should connect GET /journals/ to journals#index' do
    expect(get('/journals/')).to route_to(controller: 'journals',
                                          action: 'index')
  end

  it 'should connect GET /journals/:id/diff to journals#idff' do
    expect(get('/journals/123/diff/description'))
      .to route_to(controller: 'journals',
                   action: 'diff',
                   field: 'description',
                   id: '123')
  end
end
