

require 'spec_helper'

describe ActivitiesController, 'routing', type: :routing do
  it {
    expect(get('/activity')).to route_to(controller: 'activities',
                                         action: 'index')
  }

  it {
    expect(get('/activity.atom')).to route_to(controller: 'activities',
                                              action: 'index',
                                              format: 'atom')
  }

  context 'project scoped' do
    it {
      expect(get('/projects/abc/activity')).to route_to(controller: 'activities',
                                                        action: 'index',
                                                        project_id: 'abc')
    }

    it {
      expect(get('/projects/abc/activity.atom')).to route_to(controller: 'activities',
                                                             action: 'index',
                                                             project_id: 'abc',
                                                             format: 'atom')
    }
  end
end
