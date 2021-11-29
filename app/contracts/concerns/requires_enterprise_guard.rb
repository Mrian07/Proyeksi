#-- encoding: UTF-8



module RequiresEnterpriseGuard
  extend ActiveSupport::Concern

  included do
    class_attribute :enterprise_action
    validate :has_enterprise
  end

  module_function

  def has_enterprise
    unless EnterpriseToken.allows_to?(enterprise_action)
      errors.add :base, :error_enterprise_only
    end
  end
end
