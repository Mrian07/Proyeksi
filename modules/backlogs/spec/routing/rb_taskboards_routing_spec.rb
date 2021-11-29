

require 'spec_helper'

describe RbTaskboardsController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/project_42/sprints/21/taskboard')).to route_to(controller: 'rb_taskboards',
                                                                           action: 'show',
                                                                           project_id: 'project_42',
                                                                           sprint_id: '21')
    }
  end
end
