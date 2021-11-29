#-- encoding: UTF-8



module Admin::Settings
  class UsersSettingsController < ::Admin::SettingsController
    menu_item :user_settings

    def default_breadcrumb
      t(:label_user_settings)
    end

    def show_local_breadcrumb
      true
    end
  end
end
