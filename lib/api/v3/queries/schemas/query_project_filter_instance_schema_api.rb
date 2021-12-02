

module API
  module V3
    module Queries
      module Schemas
        class QueryProjectFilterInstanceSchemaAPI < ::API::ProyeksiAppAPI
          resource :filter_instance_schemas do
            helpers do
              def representer
                ::API::V3::Queries::Schemas::QueryFilterInstanceSchemaCollectionRepresenter
              end
            end

            get do
              filters = Query.new(project: @project).available_filters

              representer.new(filters,
                              self_link: api_v3_paths.query_project_filter_instance_schemas(@project.id),
                              current_user: current_user)
            end
          end
        end
      end
    end
  end
end
