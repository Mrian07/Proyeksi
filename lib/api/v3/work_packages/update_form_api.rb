module API
  module V3
    module WorkPackages
      class UpdateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          post &::API::V3::Utilities::Endpoints::UpdateForm.new(model: WorkPackage,
                                                                parse_service: WorkPackages::ParseParamsService)
                                                           .mount
        end
      end
    end
  end
end
