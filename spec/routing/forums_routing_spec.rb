

require 'spec_helper'

describe ForumsController, type: :routing do
  it {
    is_expected.to route(:get, '/projects/world_domination/forums').to(controller: 'forums',
                                                                       action: 'index',
                                                                       project_id: 'world_domination')
  }
  it {
    is_expected.to route(:get, '/projects/world_domination/forums/new').to(controller: 'forums',
                                                                           action: 'new',
                                                                           project_id: 'world_domination')
  }
  it {
    is_expected.to route(:post, '/projects/world_domination/forums').to(controller: 'forums',
                                                                        action: 'create',
                                                                        project_id: 'world_domination')
  }
  it {
    is_expected.to route(:get, '/projects/world_domination/forums/44').to(controller: 'forums',
                                                                          action: 'show',
                                                                          project_id: 'world_domination',
                                                                          id: '44')
  }
  it {
    expect(get('/projects/abc/forums/1.atom'))
      .to route_to(controller: 'forums',
                   action: 'show',
                   project_id: 'abc',
                   id: '1',
                   format: 'atom')
  }
  it {
    is_expected.to route(:get, '/projects/world_domination/forums/44/edit').to(controller: 'forums',
                                                                               action: 'edit',
                                                                               project_id: 'world_domination',
                                                                               id: '44')
  }
  it {
    is_expected.to route(:put, '/projects/world_domination/forums/44').to(controller: 'forums',
                                                                          action: 'update',
                                                                          project_id: 'world_domination',
                                                                          id: '44')
  }
  it {
    is_expected.to route(:delete, '/projects/world_domination/forums/44').to(controller: 'forums',
                                                                             action: 'destroy',
                                                                             project_id: 'world_domination',
                                                                             id: '44')
  }

  it 'should connect GET /projects/:project/forums/:forum/move to forums#move' do
    expect(get('/projects/1/forums/1/move')).to route_to(controller: 'forums',
                                                         action: 'move',
                                                         project_id: '1',
                                                         id: '1')
  end

  it 'should connect POST /projects/:project/forums/:forum/move to forums#move' do
    expect(post('/projects/1/forums/1/move')).to route_to(controller: 'forums',
                                                          action: 'move',
                                                          project_id: '1',
                                                          id: '1')
  end
end
