#-- encoding: UTF-8

module PlaceholderUsers
  class BaseContract < ::ModelContract
    # attribute_alias is broken in the sense
    # that `model#changed` includes only the non-aliased name
    # hence we need to put "lastname" as an attribute here
    attribute :name
    attribute :lastname

    def self.model
      PlaceholderUser
    end

    validate :user_allowed_to_modify

    protected

    ##
    # Placeholder users can only be updated by Admins
    def user_allowed_to_modify
      unless user_allowed_to_add?
        errors.add :base, :error_unauthorized
      end
    end

    def user_allowed_to_add?
      user.allowed_to_globally?(:manage_placeholder_user)
    end
  end
end
