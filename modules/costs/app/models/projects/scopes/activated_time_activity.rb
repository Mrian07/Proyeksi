#-- encoding: UTF-8



module Projects::Scopes
  module ActivatedTimeActivity
    extend ActiveSupport::Concern

    class_methods do
      def activated_time_activity(time_entry_activity)
        join_condition = <<-SQL
          LEFT OUTER JOIN time_entry_activities_projects
            ON projects.id = time_entry_activities_projects.project_id
            AND time_entry_activities_projects.activity_id = #{time_entry_activity.id}
        SQL

        join_scope = joins(join_condition)

        result_scope = join_scope.where(time_entry_activities_projects: { active: true })

        if time_entry_activity.active?
          result_scope
            .or(join_scope.where(time_entry_activities_projects: { project_id: nil }))
        else
          result_scope
        end
      end
    end
  end
end
