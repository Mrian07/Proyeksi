#-- encoding: UTF-8

module PlaceholderUsers
  class DeleteContract < ::DeleteContract
    delete_permission -> {
      self.class.deletion_allowed?(model, user)
    }

    ##
    # Checks if a given placeholder user may be deleted by a user.
    #
    # @param actor [User] User who wants to delete the given placeholder user.
    def self.deletion_allowed?(placeholder_user,
                               actor,
                               user_allowed_service = Authorization::UserAllowedService.new(actor))
      actor.allowed_to_globally?(:manage_placeholder_user) &&
        affected_projects_managed_by_actor?(placeholder_user, user_allowed_service)
    end

    protected

    def self.affected_projects_managed_by_actor?(placeholder_user, user_allowed_service)
      placeholder_user.projects.active.empty? ||
        user_allowed_service.call(:manage_members, placeholder_user.projects.active).result
    end

    def deletion_allowed?
      self.class.deletion_allowed?(model, user)
    end
  end
end
