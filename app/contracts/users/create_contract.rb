#-- encoding: UTF-8



module Users
  class CreateContract < BaseContract
    attribute :type

    attribute :status do
      unless model.active? || model.invited?
        # New users may only have these two statuses
        errors.add :status, :invalid_on_create
      end
    end

    validate :user_allowed_to_add
    validate :authentication_defined
    validate :type_is_user

    private

    def authentication_defined
      errors.add :password, :blank if model.active? && no_auth?
    end

    def no_auth?
      model.password.blank? && model.auth_source_id.blank? && model.identity_url.blank?
    end

    ##
    # Users can only be created by Admins or users with
    # the global right to :manage_user
    def user_allowed_to_add
      unless user.allowed_to_globally?(:manage_user)
        errors.add :base, :error_unauthorized
      end
    end

    def type_is_user
      unless model.type == User.name
        errors.add(:type, 'Type and class mismatch')
      end
    end
  end
end
