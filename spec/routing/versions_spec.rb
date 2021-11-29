

require 'spec_helper'

describe 'versions routing', type: :routing do
  it {
    is_expected.to route(:get, '/versions/1').to(controller: 'versions',
                                                 action: 'show',
                                                 id: '1')
  }

  it {
    is_expected.to route(:get, '/versions/1/edit').to(controller: 'versions',
                                                      action: 'edit',
                                                      id: '1')
  }

  it {
    is_expected.to route(:patch, '/versions/1').to(controller: 'versions',
                                                   action: 'update',
                                                   id: '1')
  }

  it {
    is_expected.to route(:delete, '/versions/1').to(controller: 'versions',
                                                    action: 'destroy',
                                                    id: '1')
  }

  it {
    is_expected.to route(:get, '/versions/1/status_by').to(controller: 'versions',
                                                           action: 'status_by',
                                                           id: '1')
  }

  context 'project scoped' do
    it {
      is_expected.to route(:get, '/projects/foo/versions/new').to(controller: 'versions',
                                                                  action: 'new',
                                                                  project_id: 'foo')
    }

    it {
      is_expected.to route(:post, '/projects/foo/versions').to(controller: 'versions',
                                                               action: 'create',
                                                               project_id: 'foo')
    }

    it {
      is_expected.to route(:put, '/projects/foo/versions/close_completed').to(controller: 'versions',
                                                                              action: 'close_completed',
                                                                              project_id: 'foo')
    }

    it {
      is_expected.to route(:get, '/projects/foo/roadmap').to(controller: 'versions',
                                                             action: 'index',
                                                             project_id: 'foo')
    }
  end
end
