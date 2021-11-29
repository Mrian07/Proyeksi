#-- encoding: UTF-8



module TimeEntries
  class CreateContract < BaseContract
    validate :user_allowed_to_add
    validate :validate_user_current_user

    private

    def user_allowed_to_add
      if model.project && !user.allowed_to?(:log_time, model.project)
        errors.add :base, :error_unauthorized
      end
    end

    def validate_user_current_user
      errors.add :user_id, :not_current_user if model.user != user
    end
  end
end
