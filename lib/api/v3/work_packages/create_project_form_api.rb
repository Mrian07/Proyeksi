module API
  module V3
    module WorkPackages
      class CreateProjectFormAPI < ::API::ProyeksiAppAPI
        resource :form do
          post &::API::V3::Utilities::Endpoints::CreateForm.new(model: WorkPackage,
                                                                parse_service: WorkPackages::ParseParamsService,
                                                                instance_generator: ->(*) {
                                                                  WorkPackage.new(project: @project)
                                                                })
                                                           .mount
        end
      end
    end
  end
end
