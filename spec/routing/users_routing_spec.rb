

require 'spec_helper'

describe UsersController, 'routing', type: :routing do
  it {
    is_expected.to route(:get, '/users').to(controller: 'users',
                                            action: 'index')
  }

  it {
    expect(get('/users.xml'))
      .to route_to controller: 'users',
                   action: 'index',
                   format: 'xml'
  }

  it {
    is_expected.to route(:get, '/users/44').to(controller: 'users',
                                               action: 'show',
                                               id: '44')
  }

  it {
    expect(get('/users/44.xml'))
      .to route_to controller: 'users',
                   action: 'show',
                   id: '44',
                   format: 'xml'
  }

  it {
    is_expected.to route(:get, '/users/current').to(controller: 'users',
                                                    action: 'show',
                                                    id: 'current')
  }

  it {
    expect(get('/users/current.xml'))
      .to route_to controller: 'users',
                   action: 'show',
                   id: 'current',
                   format: 'xml'
  }

  it {
    is_expected.to route(:get, '/users/new').to(controller: 'users',
                                                action: 'new')
  }

  it {
    is_expected.to route(:get, '/users/444/edit').to(controller: 'users',
                                                     action: 'edit',
                                                     id: '444')
  }

  it {
    is_expected.to route(:get, '/users/222/edit/membership').to(controller: 'users',
                                                                action: 'edit',
                                                                id: '222',
                                                                tab: 'membership')
  }

  it {
    is_expected.to route(:post, '/users').to(controller: 'users',
                                             action: 'create')
  }

  it {
    expect(post('/users.xml'))
      .to route_to controller: 'users',
                   action: 'create',
                   format: 'xml'
  }

  it {
    is_expected.to route(:put, '/users/444').to(controller: 'users',
                                                action: 'update',
                                                id: '444')
  }

  it {
    expect(put('/users/444.xml'))
      .to route_to controller: 'users',
                   action: 'update',
                   id: '444',
                   format: 'xml'
  }

  it {
    expect(get('/users/1/change_status/foobar'))
      .to route_to controller: 'users',
                   action: 'change_status_info',
                   id: '1',
                   change_action: 'foobar'
  }
  it {
    expect(get('/users/1/deletion_info')).to route_to(controller: 'users',
                                                      action: 'deletion_info',
                                                      id: '1')
  }

  it {
    expect(delete('/users/1')).to route_to(controller: 'users',
                                           action: 'destroy',
                                           id: '1')
  }
end
