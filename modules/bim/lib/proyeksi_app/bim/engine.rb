#-- encoding: UTF-8



require 'proyeksi_app/plugins'

module ProyeksiApp::Bim
  class Engine < ::Rails::Engine
    engine_name :proyeksiapp_bim

    include ProyeksiApp::Plugins::ActsAsOpEngine

    register 'proyeksiapp-bim',
             author_url: 'https://www.proyeksiapp.org',
             settings: {
               default: {
               }
             } do
      project_module(:bim,
                     if: ->(*) { ProyeksiApp::Configuration.bim? }) do
        permission :view_ifc_models,
                   {
                     'bim/ifc_models/ifc_models': %i[index show defaults],
                     'bim/ifc_models/ifc_viewer': %i[show]
                   },
                   contract_actions: { ifc_models: %i[read] }
        permission :manage_ifc_models,
                   { 'bim/ifc_models/ifc_models': %i[index show destroy edit update create new] },
                   dependencies: %i[view_ifc_models],
                   contract_actions: { ifc_models: %i[create update destroy] }
        permission :view_linked_issues,
                   { 'bim/bcf/issues': %i[index] },
                   dependencies: %i[view_work_packages],
                   contract_actions: { bcf: %i[read] }
        permission :manage_bcf,
                   { 'bim/bcf/issues': %i[index upload prepare_import configure_import perform_import] },
                   dependencies: %i[view_linked_issues
                                    view_work_packages
                                    add_work_packages
                                    edit_work_packages],
                   contract_actions: { bcf: %i[create update] }
        permission :delete_bcf,
                   {},
                   dependencies: %i[view_linked_issues
                                    manage_bcf
                                    view_work_packages
                                    add_work_packages
                                    edit_work_packages
                                    delete_work_packages],
                   contract_actions: { bcf: %i[destroy] }
      end

      ProyeksiApp::AccessControl.permission(:view_work_packages).controller_actions << 'bim/bcf/issues/redirect_to_bcf_issues_list'

      ::Redmine::MenuManager.map(:project_menu) do |menu|
        menu.push(:ifc_models,
                  { controller: '/bim/ifc_models/ifc_models', action: 'defaults' },
                  caption: :'bcf.label_bcf',
                  after: :work_packages,
                  icon: 'icon2 icon-bcf',
                  badge: :label_new)

        menu.push :ifc_viewer_panels,
                  { controller: '/bim/ifc_models/ifc_models', action: 'defaults' },
                  parent: :ifc_models,
                  partial: '/bim/ifc_models/ifc_models/panels'
      end
    end

    class_inflection_override('v2_1' => 'V2_1')

    assets %w(bim/logo_proyeksiapp_bim_big.png)

    patches %i[Attachment WorkPackage Type Journal RootSeeder Project FogFileUploader]

    patch_with_namespace :ProyeksiApp, :CustomStyles, :ColorThemes
    patch_with_namespace :API, :V3, :Activities, :ActivityRepresenter
    patch_with_namespace :API, :V3, :WorkPackages, :EagerLoading, :Checksum

    patch_with_namespace :DemoData, :QueryBuilder
    patch_with_namespace :DemoData, :ProjectSeeder
    patch_with_namespace :DemoData, :WorkPackageSeeder
    patch_with_namespace :DemoData, :WorkPackageBoardSeeder

    extend_api_response(:v3, :work_packages, :work_package) do
      include API::Bim::Utilities::PathHelper

      link :bcfTopic,
           cache_if: -> { current_user_allowed_to(:view_linked_issues) } do
        next unless represented.bcf_issue?

        {
          href: bcf_v2_1_paths.topic(represented.project.identifier, represented.bcf_issue.uuid)
        }
      end

      link :convertBCF,
           cache_if: -> { current_user_allowed_to(:manage_bcf) } do
        next if represented.bcf_issue? || represented.project.nil?

        {
          href: bcf_v2_1_paths.topics(represented.project.identifier),
          title: 'Convert to BCF',
          payload: { reference_links: [api_v3_paths.work_package(represented.id)] },
          method: :post
        }
      end

      links :bcfViewpoints,
            cache_if: -> { current_user_allowed_to(:view_linked_issues) } do
        next unless represented.bcf_issue?

        represented.bcf_issue.viewpoints.map do |viewpoint|
          {
            href: bcf_v2_1_paths.viewpoint(represented.project.identifier, represented.bcf_issue.uuid, viewpoint.uuid)
          }
        end
      end
    end

    extend_api_response(:v3, :work_packages, :work_package_collection) do
      require_relative 'patches/api/v3/export_formats'

      prepend Patches::API::V3::ExportFormats
    end

    extend_api_response(:v3, :work_packages, :schema, :work_package_schema) do
      schema :bcf_thumbnail,
             type: 'BCF Thumbnail',
             required: false,
             writable: false,
             show_if: ->(*) { represented&.project&.module_enabled?(:bim) }
    end

    extend_api_response(:v3, :activities, :activity) do
      include API::Bim::Utilities::PathHelper

      links :bcfViewpoints do
        journable = represented.journable
        next unless current_user_allowed_to(:view_linked_issues) && represented.bcf_comment.present? && journable.bcf_issue?

        # There will only be one viewpoint per comment but we nevertheless return a collection here so that it is more
        # similar to the work package representer.
        Array(represented.bcf_comment.viewpoint).map do |viewpoint|
          {
            href: bcf_v2_1_paths.viewpoint(journable.project.identifier,
                                           journable.bcf_issue.uuid,
                                           viewpoint.uuid)
          }
        end
      end
    end

    add_api_path :bcf_xml do |project_id|
      "#{project(project_id)}/bcf_xml"
    end

    config.to_prepare do
      require_relative 'hooks'
    end

    initializer 'bim.bcf.register_hooks' do
      # don't use require_dependency to not reload hooks in development mode
      require 'proyeksi_app/xls_export/hooks/work_package_hook'
    end

    initializer 'bim.bcf.register_mimetypes' do
      Mime::Type.register "application/octet-stream", :bcf unless Mime::Type.lookup_by_extension(:bcf)
      Mime::Type.register "application/octet-stream", :bcfzip unless Mime::Type.lookup_by_extension(:bcfzip)
    end

    initializer 'bim.bcf.add_api_scope' do
      Doorkeeper.configuration.scopes.add(:bcf_v2_1)

      module ProyeksiApp::Authentication::Scope
        BCF_V2_1 = :bcf_v2_1
      end

      ProyeksiApp::Authentication.update_strategies(ProyeksiApp::Authentication::Scope::BCF_V2_1,
                                                    store: false) do |_strategies|
        %i[oauth session]
      end
    end

    config.to_prepare do
      ::Exports::Register.register do
        list ::WorkPackage, ProyeksiApp::Bim::BcfXml::Exporter
        formatter ::WorkPackage, ProyeksiApp::Bim::WorkPackage::Exporter::Formatters::BcfThumbnail
      end

      ::Queries::Register.filter ::Query, ::Bim::Queries::WorkPackages::Filter::BcfIssueAssociatedFilter
      ::Queries::Register.column ::Query, ::Bim::Queries::WorkPackages::Columns::BcfThumbnailColumn

      ::API::Root.class_eval do
        content_type :binary, 'application/octet-stream'
        default_format :binary
        version 'v1', using: :path do
          mount ::API::Bim::BcfXml::V1::BcfXmlAPI
        end
      end
    end
  end
end
