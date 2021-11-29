#-- encoding: UTF-8



module Projects::Scopes
  module VisibleWithActivatedTimeActivity
    extend ActiveSupport::Concern

    class_methods do
      def visible_with_activated_time_activity(activity)
        allowed_scope
          .where(id: activated_time_activity(activity).select(:id))
      end

      private

      def allowed_scope
        where(id: allowed_to(User.current, :view_time_entries).select(:id))
          .or(where(id: Project.allowed_to(User.current, :view_own_time_entries).select(:id)))
      end
    end
  end
end
