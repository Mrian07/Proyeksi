#-- encoding: UTF-8



module Admin::Settings
  class AuthenticationSettingsController < ::Admin::SettingsController
    menu_item :authentication_settings

    def default_breadcrumb
      t(:label_authentication)
    end

    def show_local_breadcrumb
      true
    end
  end
end
