#-- encoding: UTF-8

require 'api/v3/projects/project_collection_representer'

module API
  module V3
    module Versions
      class ProjectsByVersionAPI < ::API::ProyeksiAppAPI
        resources :projects do
          after_validation do
            @projects = @version.projects.visible(current_user)

            # Authorization for accessing the version is done in the versions
            # endpoint into which this endpoint is embedded.
          end

          get do
            path = api_v3_paths.projects_by_version @version.id
            Projects::ProjectCollectionRepresenter
              .new(@projects,
                   self_link: path,
                   current_user: current_user)
          end
        end
      end
    end
  end
end
