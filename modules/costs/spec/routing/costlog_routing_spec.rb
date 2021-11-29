

require 'spec_helper'

describe CostlogController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/blubs/cost_entries/new')).to route_to(controller: 'costlog',
                                                                  action: 'new',
                                                                  project_id: 'blubs')
    }

    it {
      expect(post('/projects/blubs/cost_entries')).to route_to(controller: 'costlog',
                                                               action: 'create',
                                                               project_id: 'blubs')
    }

    it {
      expect(get('/work_packages/5/cost_entries/new')).to route_to(controller: 'costlog',
                                                                   action: 'new',
                                                                   work_package_id: '5')
    }

    it {
      expect(get('/cost_entries/5/edit')).to route_to(controller: 'costlog',
                                                      action: 'edit',
                                                      id: '5')
    }

    it {
      expect(put('/cost_entries/5')).to route_to(controller: 'costlog',
                                                 action: 'update',
                                                 id: '5')
    }

    it {
      expect(delete('/cost_entries/5')).to route_to(controller: 'costlog',
                                                    action: 'destroy',
                                                    id: '5')
    }
  end
end
