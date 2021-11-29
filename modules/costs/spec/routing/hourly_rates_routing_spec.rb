

require 'spec_helper'

describe HourlyRatesController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/blubs/hourly_rates/5')).to route_to(controller: 'hourly_rates',
                                                                action: 'show',
                                                                project_id: 'blubs',
                                                                id: '5')
    }

    it {
      expect(get('/projects/blubs/hourly_rates/5/edit')).to route_to(controller: 'hourly_rates',
                                                                     action: 'edit',
                                                                     project_id: 'blubs',
                                                                     id: '5')
    }

    it {
      expect(get('/hourly_rates/5/edit')).to route_to(controller: 'hourly_rates',
                                                      action: 'edit',
                                                      id: '5')
    }

    it {
      expect(put('/projects/blubs/hourly_rates/5')).to route_to(controller: 'hourly_rates',
                                                                action: 'update',
                                                                project_id: 'blubs',
                                                                id: '5')
    }

    it {
      expect(post('/projects/blubs/hourly_rates/5/set_rate')).to route_to(controller: 'hourly_rates',
                                                                          action: 'set_rate',
                                                                          project_id: 'blubs',
                                                                          id: '5')
    }
  end
end
