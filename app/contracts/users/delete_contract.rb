#-- encoding: UTF-8



module Users
  class DeleteContract < ::DeleteContract
    delete_permission -> {
      self.class.deletion_allowed?(model, user)
    }

    ##
    # Checks if a given user may be deleted by another one.
    #
    # @param user [User] User to be deleted.
    # @param actor [User] User who wants to delete the given user.
    def self.deletion_allowed?(user, actor)
      if actor == user
        Setting.users_deletable_by_self?
      else
        actor.admin? && actor.active? && Setting.users_deletable_by_admins?
      end
    end
  end
end
