

module Costs
  module DeletedUserFallback
    def self.included(base)
      base.prepend InstanceMethods
    end

    module InstanceMethods
      def user(force_reload = true)
        associated_user = super()

        associated_user = reload_user if force_reload && !associated_user.nil?

        if associated_user.nil? && read_attribute(:user_id).present?
          associated_user = DeletedUser.first
        end

        associated_user
      end
    end
  end
end
