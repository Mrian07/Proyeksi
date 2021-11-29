#-- encoding: UTF-8



module RequiresAdminGuard
  extend ActiveSupport::Concern

  included do
    validate { validate_admin_only(user, errors) }
  end

  module_function

  def validate_admin_only(user, errors)
    unless user.admin? && user.active?
      errors.add :base, :error_unauthorized
    end
  end
end
