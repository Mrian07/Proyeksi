#-- encoding: UTF-8



class Projects::Settings::StorageController < Projects::SettingsController
  menu_item :settings_storage

  def show
    render locals: { storage: @project.count_required_storage }
  end
end
