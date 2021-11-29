#-- encoding: UTF-8



require 'open_project/plugins'

module OpenProject::AuthPlugins
  class Engine < ::Rails::Engine
    engine_name :openproject_auth_plugins

    include OpenProject::Plugins::ActsAsOpEngine

    register 'openproject-auth_plugins',
             author_url: 'https://www.openproject.org',
             bundled: true

    initializer 'auth_plugins.register_hooks' do
      require 'open_project/auth_plugins/hooks'
    end
  end
end
