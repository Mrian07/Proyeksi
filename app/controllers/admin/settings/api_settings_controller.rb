#-- encoding: UTF-8



module Admin::Settings
  class APISettingsController < ::Admin::SettingsController
    menu_item :settings_api

    def default_breadcrumb
      t(:label_api_access_key_type)
    end

    def settings_params
      super.tap do |settings|
        settings["apiv3_cors_origins"] = settings["apiv3_cors_origins"].split(/\r?\n/)
      end
    end
  end
end
