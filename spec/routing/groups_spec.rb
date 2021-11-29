

require 'spec_helper'

describe 'groups routes', type: :routing do
  it {
    is_expected.to route(:get, '/admin/groups').to(controller: 'groups',
                                                   action: 'index')
  }

  it {
    is_expected.to route(:get, '/admin/groups/new').to(controller: 'groups',
                                                       action: 'new')
  }

  it {
    is_expected.to route(:post, '/admin/groups').to(controller: 'groups',
                                                    action: 'create')
  }

  it {
    is_expected.to route(:get, '/groups/4').to(controller: 'groups',
                                               action: 'show',
                                               id: '4')
  }

  it {
    is_expected.to route(:get, '/admin/groups/4/edit').to(controller: 'groups',
                                                          action: 'edit',
                                                          id: '4')
  }

  it {
    is_expected.to route(:put, '/admin/groups/4').to(controller: 'groups',
                                                     action: 'update',
                                                     id: '4')
  }

  it {
    is_expected.to route(:delete, '/admin/groups/4').to(controller: 'groups',
                                                        action: 'destroy',
                                                        id: '4')
  }

  it {
    is_expected.to route(:post, '/admin/groups/4/members').to(controller: 'groups',
                                                              action: 'add_users',
                                                              id: '4')
  }

  it {
    is_expected.to route(:delete, '/admin/groups/4/members/5').to(controller: 'groups',
                                                                  action: 'remove_user',
                                                                  id: '4',
                                                                  user_id: '5')
  }

  it {
    is_expected.to route(:post, '/admin/groups/4/memberships').to(controller: 'groups',
                                                                  action: 'create_memberships',
                                                                  id: '4')
  }

  it {
    is_expected.to route(:put, '/admin/groups/4/memberships/5').to(controller: 'groups',
                                                                   action: 'edit_membership',
                                                                   id: '4',
                                                                   membership_id: '5')
  }

  it {
    is_expected.to route(:delete, '/admin/groups/4/memberships/5').to(controller: 'groups',
                                                                      action: 'destroy_membership',
                                                                      id: '4',
                                                                      membership_id: '5')
  }
end
