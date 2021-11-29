

module Projects
  class CopyContract < BaseContract
    protected

    def validate_model?
      options.fetch(:validate_model, false)
    end

    private

    def validate_user_allowed_to_manage
      errors.add :base, :error_unauthorized unless user.allowed_to?(:copy_projects, options[:copy_source])
    end
  end
end
