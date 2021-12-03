module API
  module V3
    module WorkPackages
      class CreateFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          post &::API::V3::Utilities::Endpoints::CreateForm.new(model: WorkPackage,
                                                                parse_service: WorkPackages::ParseParamsService)
                                                           .mount
        end
      end
    end
  end
end
