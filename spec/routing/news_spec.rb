

require 'spec_helper'

describe NewsController, 'routing', type: :routing do
  context 'project scoped' do
    it {
      is_expected.to route(:get, '/projects/567/news').to(controller: 'news',
                                                          action: 'index',
                                                          project_id: '567')
    }

    it do
      expect(get('/projects/567/news.atom'))
        .to route_to(controller: 'news',
                     action: 'index',
                     format: 'atom',
                     project_id: '567')
    end

    it {
      is_expected.to route(:get, '/projects/567/news/new').to(controller: 'news',
                                                              action: 'new',
                                                              project_id: '567')
    }

    it {
      is_expected.to route(:post, '/projects/567/news').to(controller: 'news',
                                                           action: 'create',
                                                           project_id: '567')
    }
  end

  it {
    is_expected.to route(:get, '/news').to(controller: 'news',
                                           action: 'index')
  }

  it do
    expect(get('/news.atom'))
      .to route_to(controller: 'news',
                   action: 'index',
                   format: 'atom')
  end

  it {
    is_expected.to route(:get, '/news/2').to(controller: 'news',
                                             action: 'show',
                                             id: '2')
  }

  it {
    is_expected.to route(:get, '/news/234').to(controller: 'news',
                                               action: 'show',
                                               id: '234')
  }

  it {
    is_expected.to route(:get, '/news/567/edit').to(controller: 'news',
                                                    action: 'edit',
                                                    id: '567')
  }

  it {
    is_expected.to route(:put, '/news/567').to(controller: 'news',
                                               action: 'update',
                                               id: '567')
  }

  it {
    is_expected.to route(:delete, '/news/567').to(controller: 'news',
                                                  action: 'destroy',
                                                  id: '567')
  }
end
