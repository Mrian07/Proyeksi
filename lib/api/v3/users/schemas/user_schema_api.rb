

module API
  module V3
    module Users
      module Schemas
        class UserSchemaAPI < ::API::OpenProjectAPI
          resources :schema do
            get &::API::V3::Utilities::Endpoints::Schema.new(model: User).mount
          end
        end
      end
    end
  end
end
