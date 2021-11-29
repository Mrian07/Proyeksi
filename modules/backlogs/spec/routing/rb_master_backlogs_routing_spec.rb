

require 'spec_helper'

describe RbMasterBacklogsController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/project_42/backlogs')).to route_to(controller: 'rb_master_backlogs',
                                                               action: 'index',
                                                               project_id: 'project_42')
    }
  end
end
