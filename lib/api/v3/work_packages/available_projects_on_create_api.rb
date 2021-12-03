require 'api/v3/projects/project_collection_representer'

module API
  module V3
    module WorkPackages
      class AvailableProjectsOnCreateAPI < ::API::ProyeksiAppAPI
        resource :available_projects do
          after_validation do
            authorize(:add_work_packages, global: true)
          end

          params do
            optional :for_type, type: Integer
          end

          get do
            checked_permissions = Projects::ProjectCollectionRepresenter.checked_permissions
            current_user.preload_projects_allowed_to(checked_permissions)

            available_projects = WorkPackage
                                   .allowed_target_projects_on_create(current_user)
                                   .includes(Projects::ProjectCollectionRepresenter.to_eager_load)

            query = ::Queries::Projects::ProjectQuery.new(user: current_user)
            if params[:for_type]
              query.where('type_id', '=', params[:for_type])
              available_projects = query.results.merge(available_projects)
            end

            self_link = api_v3_paths.available_projects_on_create(params[:for_type])
            Projects::ProjectCollectionRepresenter.new(available_projects,
                                                       self_link: self_link,
                                                       current_user: current_user)
          end
        end
      end
    end
  end
end
