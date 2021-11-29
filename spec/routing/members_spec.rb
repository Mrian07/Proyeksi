

require 'spec_helper'

describe MembersController, type: :routing do
  context 'project scoped' do
    it {
      is_expected.to route(:post, '/projects/5234/members').to(controller: 'members',
                                                               action: 'create',
                                                               project_id: '5234')
    }

    it {
      is_expected.to route(:get, '/projects/5234/members/autocomplete_for_member')
                       .to(controller: 'members',
                           action: 'autocomplete_for_member',
                           project_id: '5234')
    }
  end

  it {
    is_expected.to route(:put, '/members/5234').to(controller: 'members',
                                                   action: 'update',
                                                   id: '5234')
  }

  it {
    is_expected.to route(:delete, '/members/5234').to(controller: 'members',
                                                      action: 'destroy',
                                                      id: '5234')
  }
end
