

require 'api/v3/queries/query_representer'

module API
  module V3
    module Queries
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          helpers ::API::V3::Queries::QueryHelper

          post do
            create_or_update_query_form Query.new_default, ::Queries::CreateContract, CreateFormRepresenter
          end
        end
      end
    end
  end
end
