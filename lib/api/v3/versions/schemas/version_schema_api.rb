

module API
  module V3
    module Versions
      module Schemas
        class VersionSchemaAPI < ::API::ProyeksiAppAPI
          resources :schema do
            before do
              authorize_any %i[manage_versions view_work_packages],
                            global: true
            end

            get &::API::V3::Utilities::Endpoints::Schema.new(model: Version).mount
          end
        end
      end
    end
  end
end
