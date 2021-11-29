#-- encoding: UTF-8



require 'api/v3/versions/version_collection_representer'

module API
  module V3
    module Versions
      class VersionsByProjectAPI < ::API::OpenProjectAPI
        resources :versions do
          after_validation do
            @versions = @project.shared_versions

            authorize_any %i(view_work_packages manage_versions), projects: @project
          end

          get do
            ::API::V3::Utilities::ParamsToQuery.collection_response(@versions,
                                                                    current_user,
                                                                    params.except('id'),
                                                                    self_link: api_v3_paths.versions_by_project(@project.id))
          end
        end
      end
    end
  end
end
