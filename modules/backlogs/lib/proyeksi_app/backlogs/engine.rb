

require 'proyeksi_app/plugins'
require_relative './patches/api/work_package_representer'
require_relative './patches/api/work_package_schema_representer'

module ProyeksiApp::Backlogs
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_backlogs

    def self.settings
      {
        default: {
          'story_types' => nil,
          'task_type' => nil,
          'card_spec' => nil
        },
        menu_item: :backlogs_settings
      }
    end

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-backlogs',
             author_url: 'https://www.proyeksiapp.org',
             bundled: true,
             settings: settings do
      ProyeksiApp::AccessControl.permission(:add_work_packages).tap do |add|
        add.controller_actions << 'rb_stories/create'
        add.controller_actions << 'rb_tasks/create'
        add.controller_actions << 'rb_impediments/create'
      end

      ProyeksiApp::AccessControl.permission(:edit_work_packages).tap do |edit|
        edit.controller_actions << 'rb_stories/update'
        edit.controller_actions << 'rb_tasks/update'
        edit.controller_actions << 'rb_impediments/update'
      end

      project_module :backlogs, dependencies: :work_package_tracking do
        # SYNTAX: permission :name_of_permission, { :controller_name => [:action1, :action2] }

        # Master backlog permissions
        permission :view_master_backlog,
                   rb_master_backlogs: :index,
                   rb_sprints: %i[index show],
                   rb_wikis: :show,
                   rb_stories: %i[index show],
                   rb_queries: :show,
                   rb_burndown_charts: :show,
                   rb_export_card_configurations: %i[index show]

        permission :view_taskboards,
                   rb_taskboards: :show,
                   rb_sprints: :show,
                   rb_stories: :show,
                   rb_tasks: %i[index show],
                   rb_impediments: %i[index show],
                   rb_wikis: :show,
                   rb_burndown_charts: :show,
                   rb_export_card_configurations: %i[index show]

        permission :select_done_statuses,
                   {
                     'projects/settings/backlogs': %i[show update rebuild_positions]
                   },
                   require: :member

        # Sprint permissions
        # :show_sprints and :list_sprints are implicit in :view_master_backlog permission
        permission :update_sprints,
                   {
                     rb_sprints: %i[edit update],
                     rb_wikis: %i[edit update]
                   },
                   require: :member
      end

      menu :project_menu,
           :backlogs,
           { controller: '/rb_master_backlogs', action: :index },
           caption: :project_module_backlogs,
           before: :calendar,
           icon: 'icon2 icon-backlogs'

      menu :project_menu,
           :settings_backlogs,
           { controller: '/projects/settings/backlogs', action: :show },
           caption: :label_backlogs,
           parent: :settings,
           before: :settings_storage
    end

    # We still override version and project settings views from the core! URH
    override_core_views!

    patches %i[PermittedParams
               WorkPackage
               Status
               Type
               Project
               User
               VersionsController
               Version]

    patch_with_namespace :API, :V3, :WorkPackages, :Schema, :SpecificWorkPackageSchema
    patch_with_namespace :BasicData, :SettingSeeder
    patch_with_namespace :DemoData, :ProjectSeeder
    patch_with_namespace :WorkPackages, :UpdateAncestorsService
    patch_with_namespace :WorkPackages, :UpdateService
    patch_with_namespace :WorkPackages, :SetAttributesService
    patch_with_namespace :WorkPackages, :BaseContract
    patch_with_namespace :Versions, :RowCell

    config.to_prepare do
      next if Versions::BaseContract.included_modules.include?(ProyeksiApp::Backlogs::Patches::Versions::BaseContractPatch)

      Versions::BaseContract.prepend(ProyeksiApp::Backlogs::Patches::Versions::BaseContractPatch)

      # Add available settings to the user preferences
      UserPreferences::Schema.merge!(
        'definitions/UserPreferences/properties',
        {
          'backlogs_task_color' => {
            'type' => 'string'
          },
          'backlogs_versions_default_fold_state' => {
            'type' => 'string',
            "enum" => %w[open closed]
          }
        }
      )
    end

    extend_api_response(:v3, :work_packages, :work_package,
                        &::ProyeksiApp::Backlogs::Patches::API::WorkPackageRepresenter.extension)

    extend_api_response(:v3, :work_packages, :work_package_payload,
                        &::ProyeksiApp::Backlogs::Patches::API::WorkPackageRepresenter.extension)

    extend_api_response(:v3, :work_packages, :schema, :work_package_schema,
                        &::ProyeksiApp::Backlogs::Patches::API::WorkPackageSchemaRepresenter.extension)

    add_api_attribute on: :work_package, ar_name: :story_points
    add_api_attribute on: :work_package, ar_name: :remaining_hours, writeable: ->(*) { model.leaf? }

    add_api_path :backlogs_type do |id|
      # There is no api endpoint for this url
      "#{root}/backlogs_types/#{id}"
    end

    initializer 'backlogs.register_hooks' do
      require 'proyeksi_app/backlogs/hooks'
      require 'proyeksi_app/backlogs/hooks/user_settings_hook'
    end

    config.to_prepare do
      ::Type.add_constraint :position, ->(type, project: nil) do
        if project.present?
          project.backlogs_enabled? && type.story?
        else
          # Allow globally configuring the attribute if story
          type.story?
        end
      end

      ::Type.add_constraint :story_points, ->(type, project: nil) do
        if project.present?
          project.backlogs_enabled? && type.story?
        else
          # Allow globally configuring the attribute if story
          type.story?
        end
      end

      ::Type.add_constraint :remaining_time, ->(_type, project: nil) do
        project.nil? || project.backlogs_enabled?
      end

      ::Type.add_default_mapping(:estimates_and_time, :story_points, :remaining_time)
      ::Type.add_default_mapping(:other, :position)

      Queries::Register.filter Query, ProyeksiApp::Backlogs::WorkPackageFilter
      Queries::Register.column Query, ProyeksiApp::Backlogs::QueryBacklogsColumn
    end
  end
end
