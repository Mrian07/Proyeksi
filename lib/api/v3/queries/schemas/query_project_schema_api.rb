module API
  module V3
    module Queries
      module Schemas
        class QueryProjectSchemaAPI < ::API::ProyeksiAppAPI
          resource :schema do
            helpers do
              def representer
                ::API::V3::Queries::Schemas::QuerySchemaRepresenter
              end
            end

            get do
              representer.new(Query.new(project: @project),
                              self_link: api_v3_paths.query_project_schema(@project.id),
                              current_user: current_user,
                              form_embedded: false)
            end
          end
        end
      end
    end
  end
end
