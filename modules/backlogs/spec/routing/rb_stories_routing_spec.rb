

require 'spec_helper'

describe RbStoriesController, type: :routing do
  describe 'routing' do
    it {
      expect(post('/projects/project_42/sprints/21/stories')).to route_to(controller: 'rb_stories',
                                                                          action: 'create',
                                                                          project_id: 'project_42',
                                                                          sprint_id: '21')
    }
    it {
      expect(put('/projects/project_42/sprints/21/stories/85')).to route_to(controller: 'rb_stories',
                                                                            action: 'update',
                                                                            project_id: 'project_42',
                                                                            sprint_id: '21',
                                                                            id: '85')
    }
  end
end
