

module API
  module V3
    module TimeEntries
      class AvailableWorkPackagesOnCreateAPI < ::API::ProyeksiAppAPI
        after_validation do
          authorize_any %i[log_time],
                        global: true
        end

        helpers AvailableWorkPackagesHelper

        helpers do
          def allowed_scope
            WorkPackage.where(project_id: Project.allowed_to(User.current, :log_time))
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
