#-- encoding: UTF-8



class Projects::Settings::TimeEntryActivitiesController < Projects::SettingsController
  menu_item :settings_time_entry_activities

  def update
    TimeEntryActivitiesProject.upsert_all(update_params, unique_by: %i[project_id activity_id])
    flash[:notice] = t(:notice_successful_update)

    redirect_to project_settings_time_entry_activities_path(@project)
  end

  private

  def update_params
    permitted_params.time_entry_activities_project.map do |attributes|
      { project_id: @project.id, active: false }.with_indifferent_access.merge(attributes.to_h)
    end
  end
end
