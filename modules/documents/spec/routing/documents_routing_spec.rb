

require 'spec_helper'

describe DocumentsController do
  describe "routing" do
    it {
      expect(get('/projects/567/documents')).to route_to(controller: 'documents',
                                                         action: 'index',
                                                         project_id: '567')
    }

    it {
      expect(get('/projects/567/documents/new')).to route_to(controller: 'documents',
                                                             action: 'new',
                                                             project_id: '567')
    }

    it {
      expect(get('/documents/22')).to route_to(controller: 'documents',
                                               action: 'show',
                                               id: '22')
    }

    it {
      expect(get('/documents/22/edit')).to route_to(controller: 'documents',
                                                    action: 'edit',
                                                    id: '22')
    }

    it {
      expect(post('/projects/567/documents')).to route_to(controller: 'documents',
                                                          action: 'create',
                                                          project_id: '567')
    }

    it {
      expect(put('/documents/567')).to route_to(controller: 'documents',
                                                action: 'update',
                                                id: '567')
    }

    it {
      expect(delete('/documents/567')).to route_to(controller: 'documents',
                                                   action: 'destroy',
                                                   id: '567')
    }
  end
end
