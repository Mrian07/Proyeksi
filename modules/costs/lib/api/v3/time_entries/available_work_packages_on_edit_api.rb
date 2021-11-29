

module API
  module V3
    module TimeEntries
      class AvailableWorkPackagesOnEditAPI < ::API::OpenProjectAPI
        after_validation do
          authorize_any %i[edit_time_entries edit_own_time_entries],
                        projects: @time_entry.project
        end

        helpers AvailableWorkPackagesHelper

        helpers do
          def allowed_scope
            edit_scope = WorkPackage.where(project_id: Project.allowed_to(User.current, :edit_time_entries))
            edit_own_scope = WorkPackage.where(project_id: Project.allowed_to(User.current, :edit_own_time_entries))

            edit_scope.or(edit_own_scope)
          end
        end

        resources :available_work_packages do
          get do
            available_work_packages_collection(allowed_scope)
          end
        end
      end
    end
  end
end
