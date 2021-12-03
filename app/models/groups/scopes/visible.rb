#-- encoding: UTF-8

module Groups::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      def visible(current_user = User.current)
        if current_user.allowed_to_globally?(:manage_members)
          Group.all
        else
          Group
            .in_project(Project.allowed_to(current_user, :view_members))
        end
      end
    end
  end
end
