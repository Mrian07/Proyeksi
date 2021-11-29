

require 'spec_helper'

describe MessagesController, 'routing', type: :routing do
  context 'project scoped' do
    it {
      is_expected.to route(:get, '/forums/lala/topics/new').to(controller: 'messages',
                                                               action: 'new',
                                                               forum_id: 'lala')
    }

    it {
      is_expected.to route(:post, '/forums/lala/topics').to(controller: 'messages',
                                                            action: 'create',
                                                            forum_id: 'lala')
    }
  end

  it {
    is_expected.to route(:get, '/topics/2').to(controller: 'messages',
                                               action: 'show',
                                               id: '2')
  }

  it {
    is_expected.to route(:get, '/topics/22/edit').to(controller: 'messages',
                                                     action: 'edit',
                                                     id: '22')
  }

  it {
    is_expected.to route(:put, '/topics/22').to(controller: 'messages',
                                                action: 'update',
                                                id: '22')
  }

  it {
    is_expected.to route(:delete, '/topics/555').to(controller: 'messages',
                                                    action: 'destroy',
                                                    id: '555')
  }

  it {
    is_expected.to route(:get, '/topics/22/quote').to(controller: 'messages',
                                                      action: 'quote',
                                                      id: '22')
  }

  it {
    is_expected.to route(:post, '/topics/555/reply').to(controller: 'messages',
                                                        action: 'reply',
                                                        id: '555')
  }
end
