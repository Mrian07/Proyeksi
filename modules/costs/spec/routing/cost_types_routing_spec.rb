

require 'spec_helper'

describe CostTypesController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/cost_types')).to route_to(controller: 'cost_types',
                                             action: 'index')
    }

    it {
      expect(post('/cost_types')).to route_to(controller: 'cost_types',
                                              action: 'create')
    }

    it {
      expect(get('/cost_types/new')).to route_to(controller: 'cost_types',
                                                 action: 'new')
    }

    it {
      expect(get('/cost_types/5/edit')).to route_to(controller: 'cost_types',
                                                    action: 'edit',
                                                    id: '5')
    }

    it {
      expect(put('/cost_types/5')).to route_to(controller: 'cost_types',
                                               action: 'update',
                                               id: '5')
    }

    it {
      expect(put('/cost_types/5/set_rate')).to route_to(controller: 'cost_types',
                                                        action: 'set_rate',
                                                        id: '5')
    }

    it {
      expect(delete('/cost_types/5')).to route_to(controller: 'cost_types',
                                                  action: 'destroy',
                                                  id: '5')
    }

    it {
      expect(patch('/cost_types/5/restore')).to route_to(controller: 'cost_types',
                                                         action: 'restore',
                                                         id: '5')
    }
  end
end
