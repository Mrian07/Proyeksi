#-- encoding: UTF-8



module TimeEntries::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      def visible(user = User.current)
        all_scope = TimeEntry
                    .where(project_id: Project.allowed_to(user, :view_time_entries))

        own_scope = TimeEntry
                    .where(project_id: Project.allowed_to(user, :view_own_time_entries))
                    .where(user_id: user)

        all_scope.or(own_scope)
      end
    end
  end
end
