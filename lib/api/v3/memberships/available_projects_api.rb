

module API
  module V3
    module Memberships
      class AvailableProjectsAPI < ::API::OpenProjectAPI
        after_validation do
          authorize :manage_members, global: true
        end

        resources :available_projects do
          get &::API::V3::Utilities::Endpoints::Index.new(model: Project,
                                                          scope: -> { Project.allowed_to(User.current, :manage_members) })
                                                     .mount
        end
      end
    end
  end
end
