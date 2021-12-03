#-- encoding: UTF-8

module UserPreferences
  class ParamsContract < ::ParamsContract
    validate :only_one_global_setting,
             if: -> { notifications.present? }

    validate :global_email_alerts,
             if: -> { notifications.present? }

    protected

    def only_one_global_setting
      if global_notifications.count > 1
        errors.add :notification_settings, :only_one_global_setting
      end
    end

    def global_email_alerts
      if project_notifications.any?(method(:email_alerts_set?))
        errors.add :notification_settings, :email_alerts_global
      end
    end

    ##
    # Check if the given notification hash has email-only settings set
    def email_alerts_set?(notification_setting)
      NotificationSetting.email_settings.any? do |setting|
        notification_setting[setting] == true
      end
    end

    def global_notifications
      notifications.select { |notification| notification[:project_id].nil? }
    end

    def project_notifications
      notifications.select { |notification| notification[:project_id].present? }
    end

    def notifications
      params[:notification_settings]
    end
  end
end
