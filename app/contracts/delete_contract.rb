

class DeleteContract < ModelContract
  class << self
    def delete_permission(permission = nil)
      if permission
        @delete_permission = permission
      end

      @delete_permission
    end
  end

  validate :user_allowed

  def user_allowed
    unless authorized?
      errors.add :base, :error_unauthorized
    end
  end

  protected

  def validate_model?
    false
  end

  def authorized?
    permission = self.class.delete_permission

    case permission
    when :admin
      user.admin? && user.active?
    when Proc
      instance_exec(&permission)
    else
      !model.project || user.allowed_to?(permission, model.project)
    end
  end
end
