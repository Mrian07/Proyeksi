

require 'spec_helper'

describe Users::MembershipsController, type: :routing do
  describe 'routing' do
    it 'connects DELETE users/:user_id/memberships/:id' do
      expect(delete('/users/1/memberships/2')).to route_to(controller: 'users/memberships',
                                                           action: 'destroy',
                                                           user_id: '1',
                                                           id: '2')
    end

    it 'connects PATCH users/:user_id/memberships/:id' do
      expect(patch('/users/1/memberships/2')).to route_to(controller: 'users/memberships',
                                                          action: 'update',
                                                          user_id: '1',
                                                          id: '2')
    end

    it 'connects POST users/:user_id/memberships' do
      expect(post('/users/1/memberships')).to route_to(controller: 'users/memberships',
                                                       action: 'create',
                                                       user_id: '1')
    end
  end
end
