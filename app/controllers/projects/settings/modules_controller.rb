#-- encoding: UTF-8

class Projects::Settings::ModulesController < Projects::SettingsController
  menu_item :settings_modules

  def update
    call = Projects::EnabledModulesService
             .new(model: @project, user: current_user)
             .call(enabled_modules: permitted_params.project[:enabled_module_names])

    if call.success?
      flash[:notice] = I18n.t(:notice_successful_update)

      redirect_to project_settings_modules_path(@project)
    else
      @errors = call.errors
      render 'show'
    end
  end
end
