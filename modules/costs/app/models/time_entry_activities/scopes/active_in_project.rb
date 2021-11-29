#-- encoding: UTF-8



module TimeEntryActivities::Scopes
  module ActiveInProject
    extend ActiveSupport::Concern

    class_methods do
      def active_in_project(project)
        being_active_in_project(project)
          .or(being_not_inactive_in_project(project))
      end

      private

      # All activities, that have a specific setting for the project to be active.
      # The global active state has no effect in that case.
      def being_active_in_project(project)
        where(id: of_project(project).where(active: true))
      end

      # All activities that are active and do not have a project specific setting stating
      # the activity to be inactive. So there could either be no project specific setting (for that project) or
      # a project specific setting that is active.
      def being_not_inactive_in_project(project)
        where(active: true).where.not(id: of_project(project).where(active: false))
      end

      def of_project(project)
        TimeEntryActivitiesProject.where(project_id: project.id).select(:activity_id)
      end
    end
  end
end
