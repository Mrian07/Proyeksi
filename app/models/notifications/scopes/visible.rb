module Notifications::Scopes
  module Visible
    extend ActiveSupport::Concern

    class_methods do
      # Return notifications visible to a user:
      # * the user is the recipient
      # * the user has the permission to see the associated resource
      #
      # As currently only notifications for work packages exist, the implementation is work package specific.
      def visible(user)
        recipient(user)
          .where(resource_type: 'WorkPackage', resource_id: WorkPackage.visible(user).select(:id))
      end
    end
  end
end
