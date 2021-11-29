

module API
  module V3
    module Grids
      module Schemas
        class GridSchemaAPI < ::API::OpenProjectAPI
          resources :schema do
            get &::API::V3::Utilities::Endpoints::Schema.new(model: ::Grids::Grid).mount
          end
        end
      end
    end
  end
end
