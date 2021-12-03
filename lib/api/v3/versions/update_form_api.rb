module API
  module V3
    module Versions
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          after_validation do
            authorize :manage_versions, global: true
          end

          post &::API::V3::Utilities::Endpoints::UpdateForm.new(model: Version).mount
        end
      end
    end
  end
end
