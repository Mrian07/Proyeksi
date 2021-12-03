#-- encoding: UTF-8

class Projects::Settings::VersionsController < Projects::SettingsController
  menu_item :settings_versions

  def show
    @versions = @project.shared_versions.order_by_semver_name
  end
end
