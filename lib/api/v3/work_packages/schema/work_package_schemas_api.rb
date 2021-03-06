require 'api/v3/work_packages/schema/typed_work_package_schema'
require 'api/v3/work_packages/schema/work_package_sums_schema'
require 'api/v3/work_packages/schema/work_package_schema_representer'
require 'api/v3/work_packages/schema/work_package_sums_schema_representer'

module API
  module V3
    module WorkPackages
      module Schema
        class WorkPackageSchemasAPI < ::API::ProyeksiAppAPI
          resources :schemas do
            helpers do
              def raise404
                raise ::API::Errors::NotFound.new
              end

              def raise_invalid_query
                message = I18n.t('api_v3.errors.missing_or_malformed_parameter',
                                 parameter: 'filters')

                raise ::API::Errors::InvalidQuery.new(message)
              end

              def parse_filter_for_project_type_pairs
                begin
                  filter = JSON::parse(params[:filters])
                rescue TypeError, JSON::ParseError
                  raise_invalid_query
                end

                service = ParseSchemaFilterParamsService
                            .new(user: current_user)
                            .call(filter)

                if service.success?
                  service.result
                else
                  raise_invalid_query
                end
              end

              def schemas_path_with_filters_params
                "#{api_v3_paths.work_package_schemas}?#{{ filters: params[:filters] }.to_query}"
              end
            end

            get do
              authorize(:view_work_packages, global: true)

              project_type_pairs = parse_filter_for_project_type_pairs

              schemas = project_type_pairs.map do |project, type|
                TypedWorkPackageSchema.new(project: project, type: type)
              end

              WorkPackageSchemaCollectionRepresenter.new(schemas,
                                                         self_link: schemas_path_with_filters_params,
                                                         current_user: current_user)
            end

            # The schema identifier is an artificial identifier that is composed of a work package's
            # project and its type (separated by a dash).
            # This allows to have a separate schema URL for each kind of different work packages
            # but with better caching capabilities than simply using the work package id as
            # identifier for the schema.
            params do
              requires :project, desc: 'Work package schema id'
              requires :type, desc: 'Work package schema id'
            end
            namespace ':project-:type' do
              after_validation do
                begin
                  @project = Project.find(params[:project])
                  @type = Type.find(params[:type])
                rescue ActiveRecord::RecordNotFound
                  raise404
                end

                authorize(:view_work_packages, context: @project) do
                  raise404
                end
              end

              get do
                schema = TypedWorkPackageSchema.new(project: @project, type: @type)
                self_link = api_v3_paths.work_package_schema(@project.id, @type.id)
                represented_schema = WorkPackageSchemaRepresenter.create(schema,
                                                                         self_link: self_link,
                                                                         current_user: current_user)

                with_etag! represented_schema.json_cache_key

                represented_schema
              end
            end

            namespace 'sums' do
              get do
                authorize(:view_work_packages, global: true) do
                  raise404
                end

                schema = WorkPackageSumsSchema.new
                @representer = WorkPackageSumsSchemaRepresenter.create(schema,
                                                                       current_user: current_user)
              end
            end

            # Because the namespace declaration above does not match for shorter IDs we need
            # to catch those cases (e.g. '12' instead of '12-13') here and manually return 404
            # Otherwise we get a no route error
            namespace ':id' do
              get do
                raise404
              end
            end
          end
        end
      end
    end
  end
end
