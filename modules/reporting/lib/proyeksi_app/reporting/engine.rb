

module ProyeksiApp::Reporting
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_reporting

    include ProyeksiApp::Plugins::ActsAsOpEngine

    config.eager_load_paths += Dir["#{config.root}/lib/"]

    register 'proyeksiapp-reporting',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true do
      view_actions = %i[index show drill_down available_values display_report_list]
      edit_actions = %i[create update rename destroy]

      # register reporting_module including permissions
      project_module :costs do
        permission :save_cost_reports, { cost_reports: edit_actions }
        permission :save_private_cost_reports, { cost_reports: edit_actions }
      end

      # register additional permissions for viewing time and cost entries through the CostReportsController
      view_actions.each do |action|
        ProyeksiApp::AccessControl.permission(:view_time_entries).controller_actions << "cost_reports/#{action}"
        ProyeksiApp::AccessControl.permission(:view_own_time_entries).controller_actions << "cost_reports/#{action}"
        ProyeksiApp::AccessControl.permission(:view_cost_entries).controller_actions << "cost_reports/#{action}"
        ProyeksiApp::AccessControl.permission(:view_own_cost_entries).controller_actions << "cost_reports/#{action}"
      end

      # menu extensions
      menu :top_menu,
           :cost_reports_global,
           { controller: '/cost_reports', action: 'index', project_id: nil },
           caption: :cost_reports_title,
           if: Proc.new {
             (User.current.logged? || !Setting.login_required?) &&
               (
               User.current.allowed_to?(:view_time_entries, nil, global: true) ||
                 User.current.allowed_to?(:view_own_time_entries, nil, global: true) ||
                 User.current.allowed_to?(:view_cost_entries, nil, global: true) ||
                 User.current.allowed_to?(:view_own_cost_entries, nil, global: true)
             )
           }

      menu :project_menu,
           :costs,
           { controller: '/cost_reports', action: 'index' },
           after: :news,
           caption: :cost_reports_title,
           if: Proc.new { |project| project.module_enabled?(:costs) },
           icon: 'icon2 icon-cost-reports'

      menu :project_menu,
           :costs_menu,
           { controller: '/cost_reports', action: 'index' },
           if: Proc.new { |project| project.module_enabled?(:costs) },
           partial: '/cost_reports/report_menu',
           parent: :costs
    end

    initializer "reporting.register_hooks" do
      # don't use require_dependency to not reload hooks in development mode
      require 'proyeksi_app/reporting/hooks'
    end

    initializer 'reporting.load_patches' do
      require_relative 'patches/big_decimal_patch'
      require_relative 'patches/to_date_patch'
    end

    config.to_prepare do
      require_dependency 'report/walker'
      require_dependency 'report/transformer'
      require_dependency 'widget/table/entry_table'
      require_dependency 'widget/settings_patch'
      require_dependency 'cost_query/group_by'
    end

    patches %i[CustomFieldsController ProyeksiApp::Configuration]
    patch_with_namespace :BasicData, :RoleSeeder
    patch_with_namespace :BasicData, :SettingSeeder
  end
end
