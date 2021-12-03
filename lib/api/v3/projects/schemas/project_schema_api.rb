module API
  module V3
    module Projects
      module Schemas
        class ProjectSchemaAPI < ::API::ProyeksiAppAPI
          resources :schema do
            get &::API::V3::Utilities::Endpoints::Schema.new(model: Project).mount
          end
        end
      end
    end
  end
end
