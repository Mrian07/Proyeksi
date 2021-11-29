

module Costs::Patches::ProjectsControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      before_action :own_total_hours, only: [:show]
    end
  end

  module InstanceMethods
    def own_total_hours
      if User.current.allowed_to?(:view_own_time_entries, @project)
        cond = @project.project_condition(Setting.display_subprojects_work_packages?)
        @total_hours = TimeEntry.visible.includes(:project).where(cond).sum(:hours).to_f
      end
    end
  end
end
