

require 'api/v3/work_packages/work_package_representer'

module API
  module V3
    module WorkPackages
      class WorkPackagesAPI < ::API::ProyeksiAppAPI
        resources :work_packages do
          helpers ::API::V3::WorkPackages::WorkPackagesSharedHelpers

          # The endpoint needs to be mounted before the GET :work_packages/:id.
          # Otherwise, the matcher for the :id also seems to match available_projects.
          # This is also true when the :id param is declared to be of type: Integer.
          mount ::API::V3::WorkPackages::AvailableProjectsOnCreateAPI
          mount ::API::V3::WorkPackages::Schema::WorkPackageSchemasAPI

          get do
            authorize(:view_work_packages, global: true)
            service = WorkPackageCollectionFromQueryParamsService
                      .new(current_user)
                      .call(params)

            if service.success?
              service.result
            else
              api_errors = service.errors.full_messages.map do |message|
                ::API::Errors::InvalidQuery.new(message)
              end

              raise ::API::Errors::MultipleErrors.create_if_many api_errors
            end
          end

          post &::API::V3::Utilities::Endpoints::Create.new(model: WorkPackage,
                                                            parse_service: WorkPackages::ParseParamsService,
                                                            params_modifier: ->(attributes) {
                                                              attributes[:send_notifications] = notify_according_to_params
                                                              attributes
                                                            })
                                                       .mount

          route_param :id, type: Integer, desc: 'Work package ID' do
            helpers WorkPackagesSharedHelpers

            helpers do
              attr_reader :work_package
            end

            after_validation do
              @work_package = WorkPackage.find(declared_params[:id])

              authorize(:view_work_packages, context: @work_package.project) do
                raise API::Errors::NotFound.new model: :work_package
              end
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: WorkPackage).mount

            patch &::API::V3::WorkPackages::UpdateEndPoint.new(model: WorkPackage,
                                                               parse_service: ::API::V3::WorkPackages::ParseParamsService,
                                                               params_modifier: ->(attributes) {
                                                                 attributes[:send_notifications] = notify_according_to_params
                                                                 attributes
                                                               })
                                                          .mount

            delete &::API::V3::Utilities::Endpoints::Delete.new(model: WorkPackage)
                                                           .mount

            mount ::API::V3::WorkPackages::WatchersAPI
            mount ::API::V3::Activities::ActivitiesByWorkPackageAPI
            mount ::API::V3::Attachments::AttachmentsByWorkPackageAPI
            mount ::API::V3::Repositories::RevisionsByWorkPackageAPI
            mount ::API::V3::WorkPackages::UpdateFormAPI
            mount ::API::V3::WorkPackages::AvailableProjectsOnEditAPI
            mount ::API::V3::WorkPackages::AvailableRelationCandidatesAPI
            mount ::API::V3::WorkPackages::WorkPackageRelationsAPI
          end

          mount ::API::V3::WorkPackages::CreateFormAPI
        end
      end
    end
  end
end
