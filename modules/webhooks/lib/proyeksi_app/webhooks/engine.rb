

require 'proyeksi_app/plugins'

module ProyeksiApp::Webhooks
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_webhooks

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-webhooks',
             bundled: true,
             author_url: 'https://www.proyeksiapp.org' do
      menu :admin_menu,
           :plugin_webhooks,
           { controller: 'webhooks/outgoing/admin', action: :index },
           if: Proc.new { User.current.admin? },
           parent: :in_out,
           caption: ->(*) { I18n.t('webhooks.plural') }
    end

    config.before_configuration do |app|
      # This is required for the routes to be loaded first as the routes should
      # be prepended so they take precedence over the core.
      app.config.paths['config/routes.rb'].unshift File.join(File.dirname(__FILE__), "..", "..", "..", "config", "routes.rb")
    end

    initializer 'webhooks.subscribe_to_notifications' do
      ::ProyeksiApp::Webhooks::EventResources.subscribe!
    end
  end
end
