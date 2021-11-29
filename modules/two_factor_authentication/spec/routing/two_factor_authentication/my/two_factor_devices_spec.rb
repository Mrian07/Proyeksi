

require 'spec_helper'

describe 'users 2fa devices', type: :routing do
  it 'route to index' do
    expect(get('/my/two_factor_devices')).to route_to('two_factor_authentication/my/two_factor_devices#index')
  end

  it 'route to new' do
    expect(get('/my/two_factor_devices/new')).to route_to('two_factor_authentication/my/two_factor_devices#new')
  end

  it 'route to register' do
    expect(post('/my/two_factor_devices/register')).to route_to('two_factor_authentication/my/two_factor_devices#register')
  end

  it 'route to confirm' do
    expect(get('/my/two_factor_devices/1/confirm')).to route_to(controller: 'two_factor_authentication/my/two_factor_devices',
                                                                action: 'confirm',
                                                                device_id: '1')
  end

  it 'route to POST confirm' do
    expect(post('/my/two_factor_devices/1/confirm')).to route_to(controller: 'two_factor_authentication/my/two_factor_devices',
                                                                 action: 'confirm',
                                                                 device_id: '1')
  end

  it 'route to POST make_default' do
    expect(post('/my/two_factor_devices/1/make_default')).to route_to(controller: 'two_factor_authentication/my/two_factor_devices',
                                                                      action: 'make_default',
                                                                      device_id: '1')
  end

  it 'route to DELETE destroy' do
    expect(delete('/my/two_factor_devices/1')).to route_to(controller: 'two_factor_authentication/my/two_factor_devices',
                                                           action: 'destroy',
                                                           device_id: '1')
  end
end
