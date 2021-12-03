# Prevent load-order problems in case proyeksiapp-plugins is listed after a plugin in the Gemfile
# or not at all
require 'proyeksi_app/plugins'

module Dashboards
  class Engine < ::Rails::Engine
    engine_name :dashboards

    include ProyeksiApp::Plugins::ActsAsOpEngine

    initializer 'dashboards.menu' do
      ::Redmine::MenuManager.map(:project_menu) do |menu|
        menu.push(:dashboards,
                  { controller: '/dashboards/dashboards', action: 'show' },
                  caption: :'dashboards.label',
                  after: :work_packages,
                  before: :calendar,
                  icon: 'icon2 icon-status',
                  badge: 'label_menu_badge.alpha')
      end
    end

    initializer 'dashboards.permissions' do
      # deactivate for now
      next unless Rails.env == 'test'

      ProyeksiApp::AccessControl.map do |ac_map|
        ac_map.project_module(:dashboards) do |pm_map|
          pm_map.permission(:view_dashboards, 'dashboards/dashboards': ['show'])
          pm_map.permission(:manage_dashboards, 'dashboards/dashboards': ['show'])
        end
      end
    end

    initializer 'dashboards.conversion' do
      require Rails.root.join('config', 'constants', 'ar_to_api_conversions')

      Constants::ARToAPIConversions.add('grids/dashboard': 'grid')
    end

    config.to_prepare do
      Dashboards::GridRegistration.register!
    end
  end
end
