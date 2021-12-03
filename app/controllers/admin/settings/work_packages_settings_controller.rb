#-- encoding: UTF-8

module Admin::Settings
  class WorkPackagesSettingsController < ::Admin::SettingsController
    current_menu_item :show do
      :work_packages_setting
    end

    def default_breadcrumb
      t(:label_work_package_tracking)
    end

    def show_local_breadcrumb
      true
    end
  end
end
