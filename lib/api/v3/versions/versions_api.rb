#-- encoding: UTF-8

module API
  module V3
    module Versions
      class VersionsAPI < ::API::ProyeksiAppAPI
        resources :versions do
          get &::API::V3::Utilities::Endpoints::Index.new(model: Version,
                                                          scope: -> {
                                                            # the distinct(false) is added in order to allow ORDER BY LOWER(name)
                                                            # which would otherwise be invalid in postgresql
                                                            # SELECT DISTINCT, ORDER BY expressions must appear in select list
                                                            Version.visible(current_user).distinct(false)
                                                          })
                                                     .mount

          post &::API::V3::Utilities::Endpoints::Create.new(model: Version).mount

          mount ::API::V3::Versions::AvailableProjectsAPI
          mount ::API::V3::Versions::Schemas::VersionSchemaAPI
          mount ::API::V3::Versions::CreateFormAPI

          route_param :id, type: Integer, desc: 'Version ID' do
            after_validation do
              @version = Version.find(params[:id])

              authorized_for_version?(@version)
            end

            helpers do
              def authorized_for_version?(version)
                projects = version.projects

                permissions = %i(view_work_packages manage_versions)

                authorize_any(permissions, projects: projects, user: current_user) do
                  raise ::API::Errors::NotFound.new
                end
              end
            end

            get &::API::V3::Utilities::Endpoints::Show.new(model: Version).mount
            patch &::API::V3::Utilities::Endpoints::Update.new(model: Version).mount
            delete &::API::V3::Utilities::Endpoints::Delete.new(model: Version).mount

            mount ::API::V3::Versions::UpdateFormAPI
            mount ::API::V3::Versions::ProjectsByVersionAPI
          end
        end
      end
    end
  end
end
