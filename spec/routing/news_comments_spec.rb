

require 'spec_helper'

describe News::CommentsController, 'routing', type: :routing do
  context 'news scoped' do
    it {
      is_expected.to route(:post, '/news/567/comments').to(controller: 'news/comments',
                                                           action: 'create',
                                                           news_id: '567')
    }
  end

  it {
    is_expected.to route(:delete, '/comments/15').to(controller: 'news/comments',
                                                     action: 'destroy',
                                                     id: '15')
  }
end
