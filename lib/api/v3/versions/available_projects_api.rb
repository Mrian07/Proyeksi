

module API
  module V3
    module Versions
      class AvailableProjectsAPI < ::API::OpenProjectAPI
        after_validation do
          authorize :manage_versions, global: true
        end

        resources :available_projects do
          get &::API::V3::Utilities::Endpoints::Index.new(model: Project,
                                                          scope: -> {
                                                            Project
                                                              .allowed_to(User.current, :manage_versions)
                                                              .includes(::API::V3::Projects::ProjectRepresenter.to_eager_load)
                                                          })
                                                     .mount
        end
      end
    end
  end
end
