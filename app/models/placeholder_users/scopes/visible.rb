#-- encoding: UTF-8



# Only return placeholders that are visible to the current user.
#
# Either the user has:
# - the global `manage_placeholder_user`
# - or `manage_members` permission in any project,
# - or all principals in visible projects are returned
module PlaceholderUsers::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      def visible(user = User.current)
        if user.allowed_to_globally?(:manage_placeholder_user) ||
           user.allowed_to_globally?(:manage_members)
          all
        else
          in_visible_project(user)
        end
      end
    end
  end
end
