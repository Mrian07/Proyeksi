

module API
  module V3
    module Versions
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize :manage_versions, global: true
          end

          post &::API::V3::Utilities::Endpoints::CreateForm.new(model: Version).mount
        end
      end
    end
  end
end
