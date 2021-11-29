

module API
  module V3
    module TimeEntries
      class AvailableProjectsAPI < ::API::OpenProjectAPI
        after_validation do
          authorize_any %i[log_time edit_time_entries edit_own_time_entries],
                        global: true
        end

        resources :available_projects do
          get &::API::V3::Utilities::Endpoints::Index
                 .new(model: Project,
                      scope: -> {
                        Project
                          .where(id: Project.allowed_to(User.current, :log_time))
                          .or(Project.where(id: Project.allowed_to(User.current, :edit_time_entries)))
                          .or(Project.where(id: Project.allowed_to(User.current, :edit_own_time_entries)))
                      })
                 .mount
        end
      end
    end
  end
end
