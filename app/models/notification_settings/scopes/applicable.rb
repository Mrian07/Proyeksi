#-- encoding: UTF-8

module NotificationSettings::Scopes
  module Applicable
    extend ActiveSupport::Concern

    class_methods do
      # Return notifications settings that prevail in the selected context (project)
      # If there is only the global notification setting in place, those are authoritative.
      # If there is a project specific setting in place, it is the project specific setting instead.
      # rubocop:disable Metrics/AbcSize
      def applicable(project)
        global_notifications = NotificationSetting.arel_table
        project_notifications = NotificationSetting.arel_table.alias('project_settings')

        subselect = global_notifications
                      .where(global_notifications[:project_id].eq(nil))
                      .join(project_notifications, Arel::Nodes::OuterJoin)
                      .on(project_notifications[:project_id].eq(project.id),
                          global_notifications[:user_id].eq(project_notifications[:user_id]))
                      .project(global_notifications.coalesce(project_notifications[:id], global_notifications[:id]))

        where(global_notifications[:id].in(subselect))
      end

      # rubocop:enable Metrics/AbcSize
    end
  end
end
