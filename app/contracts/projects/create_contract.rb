

module Projects
  class CreateContract < BaseContract
    private

    def validate_user_allowed_to_manage
      unless user.allowed_to_globally?(:add_project) ||
             model.parent && user.allowed_to?(:add_subprojects, model.parent)

        errors.add :base, :error_unauthorized
      end
    end
  end
end
