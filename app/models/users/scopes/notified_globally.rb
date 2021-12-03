#-- encoding: UTF-8

# Return all users who have a global setting configured
# Does not take into consideration local overrides, as
# that is currently not available for non-work-package settings
module Users::Scopes
  module NotifiedGlobally
    extend ActiveSupport::Concern

    class_methods do
      def notified_globally(setting)
        where(
          id: NotificationSetting
                .where(setting => true)
                .where(project: nil)
                .select(:user_id)
        )
      end
    end
  end
end
