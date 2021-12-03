

module API
  module V3
    module Grids
      module Schemas
        class GridSchemaAPI < ::API::ProyeksiAppAPI
          resources :schema do
            get &::API::V3::Utilities::Endpoints::Schema.new(model: ::Grids::Grid).mount
          end
        end
      end
    end
  end
end
