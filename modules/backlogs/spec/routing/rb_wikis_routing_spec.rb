

require 'spec_helper'

describe RbWikisController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/project_42/sprints/21/wiki')).to route_to(controller: 'rb_wikis',
                                                                      action: 'show',
                                                                      project_id: 'project_42',
                                                                      sprint_id: '21')
    }
    it {
      expect(get('/projects/project_42/sprints/21/wiki/edit')).to route_to(controller: 'rb_wikis',
                                                                           action: 'edit',
                                                                           project_id: 'project_42',
                                                                           sprint_id: '21')
    }
  end
end
