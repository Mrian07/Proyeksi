#-- encoding: UTF-8



##
# Implements the deletion of a user.
module Users
  class DeleteService < ::BaseServices::Delete
    ##
    # Deletes the given user if allowed.
    #
    # @return True if the user deletion has been initiated, false otherwise.
    def destroy(user_object)
      # as destroying users is a lengthy process we handle it in the background
      # and lock the account now so that no action can be performed with it
      # don't use "locked!" handle as it will raise on invalid users
      user_object.update_column(:status, User.statuses[:locked])
      ::Principals::DeleteJob.perform_later(user_object)

      logout! if self_delete?

      true
    end

    private

    def self_delete?
      user == model
    end

    def logout!
      User.current = nil
    end
  end
end
