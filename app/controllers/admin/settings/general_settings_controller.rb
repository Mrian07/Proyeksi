#-- encoding: UTF-8



module Admin::Settings
  class GeneralSettingsController < ::Admin::SettingsController
    menu_item :settings_general

    def default_breadcrumb
      t(:label_general)
    end
  end
end
