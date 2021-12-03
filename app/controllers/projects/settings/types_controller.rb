#-- encoding: UTF-8

class Projects::Settings::TypesController < Projects::SettingsController
  menu_item :settings_types

  def show
    @types = ::Type.all
  end

  def update
    if UpdateProjectsTypesService.new(@project).call(permitted_params.projects_type_ids)
      flash[:notice] = I18n.t('notice_successful_update')
    else
      flash[:error] = @project.errors.full_messages
    end

    redirect_to project_settings_types_path(@project.identifier)
  end
end
