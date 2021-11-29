

module API
  module V3
    module Projects
      module Statuses
        class StatusesAPI < ::API::OpenProjectAPI
          resources :project_statuses do
            params do
              requires :id, desc: 'Project status identifier'
            end
            route_param :id do
              helpers do
                def status_exists?
                  ::Projects::Status.codes.keys.include?(params[:id])
                end
              end

              after_validation do
                raise API::Errors::NotFound unless status_exists?
              end

              get do
                API::V3::Projects::Statuses::StatusRepresenter
                  .new(params[:id], current_user: current_user, embed_links: true)
              end
            end
          end
        end
      end
    end
  end
end
