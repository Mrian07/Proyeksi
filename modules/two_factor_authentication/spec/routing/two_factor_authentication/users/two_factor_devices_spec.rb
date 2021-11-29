

require 'spec_helper'

describe 'users 2fa devices', type: :routing do
  it 'route to GET new' do
    expect(get('/users/2/two_factor_devices/new')).to route_to(controller: 'two_factor_authentication/users/two_factor_devices',
                                                               action: 'new',
                                                               id: '2')
  end

  it 'route to POST register' do
    expect(post('/users/2/two_factor_devices/register')).to route_to(controller: 'two_factor_authentication/users/two_factor_devices',
                                                                     action: 'register',
                                                                     id: '2')
  end

  it 'route to POST confirm' do
    expect(post('/users/2/two_factor_devices/1/make_default')).to route_to(controller: 'two_factor_authentication/users/two_factor_devices',
                                                                           action: 'make_default',
                                                                           id: '2',
                                                                           device_id: '1')
  end

  it 'route to POST delete_all' do
    expect(post('/users/2/two_factor_devices/delete_all')).to route_to(controller: 'two_factor_authentication/users/two_factor_devices',
                                                                       action: 'delete_all',
                                                                       id: '2')
  end

  it 'route to DELETE destroy' do
    expect(delete('/users/2/two_factor_devices/1')).to route_to(controller: 'two_factor_authentication/users/two_factor_devices',
                                                                action: 'destroy',
                                                                id: '2',
                                                                device_id: '1')
  end
end
