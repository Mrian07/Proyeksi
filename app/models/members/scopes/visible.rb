#-- encoding: UTF-8

module Members::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      # Find all members visible to the inquiring user
      def visible(user)
        if user.admin?
          visible_for_admins
        else
          visible_for_non_admins(user)
        end
      end

      private

      def visible_for_non_admins(user)
        view_members = Project.where(id: Project.allowed_to(user, :view_members))
        manage_members = Project.where(id: Project.allowed_to(user, :manage_members))

        project_scope = view_members.or(manage_members)

        Member.where(project_id: project_scope.select(:id))
      end

      def visible_for_admins
        Member.all
      end
    end
  end
end
