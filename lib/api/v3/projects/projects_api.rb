

module API
  module V3
    module Projects
      class ProjectsAPI < ::API::ProyeksiAppAPI
        helpers do
          def visible_project_scope
            if current_user.admin?
              Project.all
            else
              Project.visible(current_user)
            end
          end
        end

        resources :projects do
          get &::API::V3::Utilities::Endpoints::Index.new(model: Project,
                                                          scope: -> {
                                                            visible_project_scope
                                                              .includes(ProjectRepresenter.to_eager_load)
                                                          })
                                                     .mount

          post &::API::V3::Utilities::Endpoints::Create.new(model: Project)
                                                       .mount

          mount ::API::V3::Projects::Schemas::ProjectSchemaAPI
          mount ::API::V3::Projects::CreateFormAPI

          mount API::V3::Projects::AvailableParentsAPI

          params do
            requires :id, desc: 'Project id'
          end
          route_param :id do
            after_validation do
              @project = visible_project_scope.find(params[:id])
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: Project).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: Project).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: Project,
                                                                process_service: ::Projects::ScheduleDeletionService)
                                                           .mount

            mount ::API::V3::Projects::UpdateFormAPI

            mount API::V3::Projects::AvailableAssigneesAPI
            mount API::V3::Projects::AvailableResponsiblesAPI
            mount API::V3::Projects::Copy::CopyAPI
            mount API::V3::WorkPackages::WorkPackagesByProjectAPI
            mount API::V3::Categories::CategoriesByProjectAPI
            mount API::V3::Versions::VersionsByProjectAPI
            mount API::V3::Types::TypesByProjectAPI
            mount API::V3::Queries::QueriesByProjectAPI
          end
        end
      end
    end
  end
end
