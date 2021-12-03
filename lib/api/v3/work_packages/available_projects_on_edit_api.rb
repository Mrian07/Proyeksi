

require 'api/v3/projects/project_collection_representer'

module API
  module V3
    module WorkPackages
      class AvailableProjectsOnEditAPI < ::API::ProyeksiAppAPI
        resource :available_projects do
          after_validation do
            authorize(:edit_work_packages, context: @work_package.project)
          end

          get do
            checked_permissions = Projects::ProjectCollectionRepresenter.checked_permissions
            current_user.preload_projects_allowed_to(checked_permissions)

            available_projects = WorkPackage
                                 .allowed_target_projects_on_move(current_user)
                                 .includes(Projects::ProjectCollectionRepresenter.to_eager_load)
            self_link = api_v3_paths.available_projects_on_edit(@work_package.id)
            Projects::ProjectCollectionRepresenter.new(available_projects,
                                                       self_link: self_link,
                                                       current_user: current_user)
          end
        end
      end
    end
  end
end
