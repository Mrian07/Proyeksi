

require 'spec_helper'

describe RbSprintsController, type: :routing do
  describe 'routing' do
    it {
      expect(put('/projects/project_42/sprints/21')).to route_to(controller: 'rb_sprints',
                                                                 action: 'update',
                                                                 project_id: 'project_42',
                                                                 id: '21')
    }
  end
end
