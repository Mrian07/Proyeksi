

require 'spec_helper'

describe 'roles routes', type: :routing do
  context 'admin scoped' do
    it {
      is_expected.to route(:get, 'admin/roles').to(controller: 'roles',
                                                   action: 'index')
    }

    it {
      is_expected.to route(:get, 'admin/roles/new').to(controller: 'roles',
                                                       action: 'new')
    }

    it {
      is_expected.to route(:post, 'admin/roles').to(controller: 'roles',
                                                    action: 'create')
    }

    it {
      is_expected.to route(:get, 'admin/roles/1/edit').to(controller: 'roles',
                                                          action: 'edit',
                                                          id: '1')
    }

    it {
      is_expected.to route(:put, 'admin/roles/1').to(controller: 'roles',
                                                     action: 'update',
                                                     id: '1')
    }

    it {
      is_expected.to route(:delete, 'admin/roles/1').to(controller: 'roles',
                                                        action: 'destroy',
                                                        id: '1')
    }

    it {
      is_expected.to route(:get, 'admin/roles/report').to(controller: 'roles',
                                                          action: 'report')
    }

    it {
      is_expected.to route(:put, 'admin/roles').to(controller: 'roles',
                                                   action: 'bulk_update')
    }
  end
end
