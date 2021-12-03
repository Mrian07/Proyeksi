module API
  module V3
    module WorkPackages
      class WorkPackagesByProjectAPI < ::API::ProyeksiAppAPI
        resources :work_packages do
          helpers ::API::V3::WorkPackages::WorkPackagesSharedHelpers

          get do
            authorize(:view_work_packages, context: @project)

            service = raise_invalid_query_on_service_failure do
              WorkPackageCollectionFromQueryParamsService
                .new(current_user)
                .call(params.merge(project: @project))
            end

            service.result
          end

          post &::API::V3::Utilities::Endpoints::Create.new(model: WorkPackage,
                                                            parse_service: WorkPackages::ParseParamsService,
                                                            params_modifier: ->(attributes) {
                                                              attributes[:project_id] = @project.id
                                                              attributes[:send_notifications] = notify_according_to_params
                                                              attributes
                                                            })
                                                       .mount

          mount ::API::V3::WorkPackages::CreateProjectFormAPI
        end
      end
    end
  end
end
