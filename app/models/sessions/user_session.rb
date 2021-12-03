#-- encoding: UTF-8

##
# An AR helper class to access sessions, but not create them.
# You can still use AR methods to delete records however.
module Sessions
  class UserSession < ::ApplicationRecord
    self.table_name = 'sessions'

    scope :for_user, ->(user) do
      user_id = user.is_a?(User) ? user.id : user.to_i

      where(user_id: user_id)
    end

    scope :non_user, -> do
      where(user_id: nil)
    end

    ##
    # Mark all records as readonly so they cannot
    # modify the database
    def readonly?
      true
    end

    def data
      SqlBypass.deserialize(super)
    end
  end
end
