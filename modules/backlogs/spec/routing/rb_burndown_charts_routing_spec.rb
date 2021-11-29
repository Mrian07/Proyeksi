

require 'spec_helper'

describe RbBurndownChartsController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/project_42/sprints/21/burndown_chart')).to route_to(controller: 'rb_burndown_charts',
                                                                                action: 'show',
                                                                                project_id: 'project_42',
                                                                                sprint_id: '21')
    }
  end
end
