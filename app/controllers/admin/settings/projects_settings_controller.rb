#-- encoding: UTF-8



module Admin::Settings
  class ProjectsSettingsController < ::Admin::SettingsController
    menu_item :settings_projects

    def default_breadcrumb
      t(:label_project_plural)
    end
  end
end
