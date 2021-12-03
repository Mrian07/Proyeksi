#-- encoding: UTF-8

# Only return Principals that are visible to the current user.
#
# Either the user has the `manage_members` permission in any project,
# or all principals in visible projects are returned.
module Principals::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      def visible(user = ::User.current)
        if user.allowed_to_globally?(:manage_members)
          all
        else
          in_visible_project_or_me(user)
        end
      end
    end
  end
end
