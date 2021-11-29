#-- encoding: UTF-8



module Users
  class UpdateContract < BaseContract
    validate :user_allowed_to_update

    private

    ##
    # Users can only be updated when
    # - the user is editing herself
    # - the user has the global manage_user CRU permission
    # - the user is an admin
    def user_allowed_to_update
      unless user == model || user.allowed_to_globally?(:manage_user)
        errors.add :base, :error_unauthorized
      end
    end
  end
end
