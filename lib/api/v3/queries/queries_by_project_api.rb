module API
  module V3
    module Queries
      class QueriesByProjectAPI < ::API::ProyeksiAppAPI
        namespace :queries do
          helpers ::API::V3::Queries::Helpers::QueryRepresenterResponse

          after_validation do
            authorize(:view_work_packages, context: @project, user: current_user)
          end

          mount API::V3::Queries::Schemas::QueryProjectFilterInstanceSchemaAPI
          mount API::V3::Queries::Schemas::QueryProjectSchemaAPI

          namespace :default do
            get do
              query = Query.new_default(name: 'default',
                                        user: current_user,
                                        project: @project)

              query_representer_response(query, params)
            end
          end
        end
      end
    end
  end
end
