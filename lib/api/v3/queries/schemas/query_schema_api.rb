

module API
  module V3
    module Queries
      module Schemas
        class QuerySchemaAPI < ::API::ProyeksiAppAPI
          resource :schema do
            helpers do
              def representer
                ::API::V3::Queries::Schemas::QuerySchemaRepresenter
              end
            end

            after_validation do
              authorize(:view_work_packages, global: true, user: current_user)
            end

            get do
              representer.new(Query.new,
                              self_link: api_v3_paths.query_schema,
                              current_user: current_user,
                              form_embedded: false)
            end
          end
        end
      end
    end
  end
end
