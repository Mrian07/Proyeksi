

require 'spec_helper'

describe EnumerationsController, 'routing', type: :routing do
  context 'admin scoped' do
    it {
      is_expected.to route(:get, 'admin/enumerations').to(controller: 'enumerations',
                                                          action: 'index')
    }

    it {
      is_expected.to route(:get, 'admin/enumerations/new').to(controller: 'enumerations',
                                                              action: 'new')
    }

    it {
      is_expected.to route(:post, 'admin/enumerations').to(controller: 'enumerations',
                                                           action: 'create')
    }

    it {
      is_expected.to route(:get, 'admin/enumerations/1/edit').to(controller: 'enumerations',
                                                                 action: 'edit',
                                                                 id: '1')
    }

    it {
      is_expected.to route(:put, 'admin/enumerations/1').to(controller: 'enumerations',
                                                            action: 'update',
                                                            id: '1')
    }

    it {
      is_expected.to route(:delete, 'admin/enumerations/1').to(controller: 'enumerations',
                                                               action: 'destroy',
                                                               id: '1')
    }
  end
end
