#-- encoding: UTF-8



require 'proyeksi_app/plugins'

module ProyeksiApp::AuthPlugins
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_auth_plugins

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-auth_plugins',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true

    initializer 'auth_plugins.register_hooks' do
      require 'proyeksi_app/auth_plugins/hooks'
    end
  end
end
