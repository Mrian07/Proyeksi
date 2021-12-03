require 'api/v3/queries/query_representer'

module API
  module V3
    module Queries
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          helpers ::API::V3::Queries::QueryHelper

          post do
            # We try to ignore invalid aspects of the query as the user
            # might not even be able to fix them (public  query)
            # and because they might only be invalid in his context
            # but not for somebody having more permissions, e.g. subproject
            # filter for admin vs for anonymous.
            # Permissions are enforced nevertheless.
            @query.valid_subset!

            create_or_update_query_form @query, ::Queries::UpdateFormContract, UpdateFormRepresenter
          end
        end
      end
    end
  end
end
