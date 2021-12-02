

ProyeksiApp::Application.routes.draw do
  namespace 'webhooks' do
    match ":hook_name", to: 'incoming/hooks#handle_hook', via: %i(get post)
  end

  scope 'admin' do
    resources :webhooks,
              param: :webhook_id,
              controller: 'webhooks/outgoing/admin',
              as: 'admin_outgoing_webhooks'
  end
end
