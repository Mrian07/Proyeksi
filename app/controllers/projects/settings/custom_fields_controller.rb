#-- encoding: UTF-8



class Projects::Settings::CustomFieldsController < Projects::SettingsController
  menu_item :settings_custom_fields

  def show
    @wp_custom_fields = WorkPackageCustomField.order(:position)
  end

  def update
    Project.transaction do
      if update_custom_fields
        flash[:notice] = t(:notice_successful_update)
      else
        flash[:error] = t(:notice_project_cannot_update_custom_fields,
                          errors: @project.errors.full_messages.join(', '))
        raise ActiveRecord::Rollback
      end
    end

    redirect_to project_settings_custom_fields_path(@project)
  end

  private

  def update_custom_fields
    @project.work_package_custom_field_ids = permitted_params.project[:work_package_custom_field_ids]
    @project.save
  end
end
