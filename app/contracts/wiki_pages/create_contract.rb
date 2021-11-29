

module WikiPages
  class CreateContract < BaseContract
    validate :validate_user_current_user

    private

    def validate_user_current_user
      errors.add :author, :not_current_user if model.content&.author != user
    end
  end
end
