

require 'spec_helper'

describe 'OpenIDConnect Providers', type: :routing do
  it 'routes to index' do
    expect(get('/admin/openid_connect/providers')).to route_to('openid_connect/providers#index')
  end

  it 'routes to new' do
    expect(get('/admin/openid_connect/providers/new')).to route_to('openid_connect/providers#new')
  end

  it 'routes to edit' do
    expect(get('/admin/openid_connect/providers/azure/edit')).to(
      route_to(
        controller: 'openid_connect/providers',
        action: 'edit',
        id: 'azure'
      )
    )
  end

  it 'routes to destroy' do
    expect(delete('/admin/openid_connect/providers/azure')).to(
      route_to(
        controller: 'openid_connect/providers',
        action: 'destroy',
        id: 'azure'
      )
    )
  end
end
