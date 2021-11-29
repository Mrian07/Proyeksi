

module Bim::Bcf::API::V2_1
  class ProjectsAPI < ::API::OpenProjectAPI
    resources :projects do
      helpers do
        def visible_projects
          Project
            .visible(current_user)
            .has_module(:bim)
        end
      end

      get &::Bim::Bcf::API::V2_1::Endpoints::Index.new(model: Project,
                                                       scope: -> { visible_projects })
                                             .mount

      route_param :id, regexp: /\A(\d+)\z/ do
        after_validation do
          @project = visible_projects
                     .find(params[:id])
        end

        get &::Bim::Bcf::API::V2_1::Endpoints::Show.new(model: Project).mount
        put &::Bim::Bcf::API::V2_1::Endpoints::Update
               .new(model: Project,
                    process_service: ::Projects::UpdateService)
               .mount

        mount ::Bim::Bcf::API::V2_1::TopicsAPI
        mount ::Bim::Bcf::API::V2_1::ProjectExtensions::API
      end
    end
  end
end
