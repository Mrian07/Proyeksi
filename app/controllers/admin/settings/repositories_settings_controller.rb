#-- encoding: UTF-8

module Admin::Settings
  class RepositoriesSettingsController < ::Admin::SettingsController
    menu_item :settings_repositories

    def default_breadcrumb
      t(:label_repository_plural)
    end
  end
end

