

require 'spec_helper'

describe 'Outgoing webhooks administration', type: :routing do
  it 'route to index' do
    expect(get('/admin/webhooks')).to route_to('webhooks/outgoing/admin#index')
  end

  it 'route to new' do
    expect(get('/admin/webhooks/new')).to route_to('webhooks/outgoing/admin#new')
  end

  it 'route to show' do
    expect(get('/admin/webhooks/1')).to route_to(controller: 'webhooks/outgoing/admin',
                                                 action: 'show',
                                                 webhook_id: '1')
  end

  it 'route to edit' do
    expect(get('/admin/webhooks/1/edit')).to route_to(controller: 'webhooks/outgoing/admin',
                                                      action: 'edit',
                                                      webhook_id: '1')
  end

  it 'route to PUT update' do
    expect(put('/admin/webhooks/1')).to route_to(controller: 'webhooks/outgoing/admin',
                                                 action: 'update',
                                                 webhook_id: '1')
  end

  it 'route to DELETE destroy' do
    expect(delete('/admin/webhooks/1')).to route_to(controller: 'webhooks/outgoing/admin',
                                                    action: 'destroy',
                                                    webhook_id: '1')
  end
end
