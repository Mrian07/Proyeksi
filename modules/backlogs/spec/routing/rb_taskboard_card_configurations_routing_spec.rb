

require 'spec_helper'

describe RbExportCardConfigurationsController, type: :routing do
  describe 'routing' do
    it {
      expect(get('/projects/project_42/sprints/21/export_card_configurations/10')).to route_to(controller: 'rb_export_card_configurations',
                                                                                               action: 'show',
                                                                                               project_id: 'project_42',
                                                                                               sprint_id: '21',
                                                                                               id: '10')
    }

    it {
      expect(get('/projects/project_42/sprints/21/export_card_configurations')).to route_to(controller: 'rb_export_card_configurations',
                                                                                            action: 'index',
                                                                                            project_id: 'project_42',
                                                                                            sprint_id: '21')
    }
  end
end
