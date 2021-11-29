#-- encoding: UTF-8



class Projects::Settings::BacklogsController < Projects::SettingsController
  menu_item :settings_backlogs

  def show
    @statuses_done_for_project = @project.done_statuses.select(:id).map(&:id)
  end

  def update
    selected_statuses = (params[:statuses] || []).map do |work_package_status|
      Status.find(work_package_status[:status_id].to_i)
    end.compact

    @project.done_statuses = selected_statuses
    @project.save!

    flash[:notice] = I18n.t(:notice_successful_update)

    redirect_to_backlogs_settings
  end

  def rebuild_positions
    @project.rebuild_positions
    flash[:notice] = I18n.t('backlogs.positions_rebuilt_successfully')

    redirect_to_backlogs_settings
  rescue ActiveRecord::ActiveRecordError
    flash[:error] = I18n.t('backlogs.positions_could_not_be_rebuilt')

    log_rebuild_position_error

    redirect_to_backlogs_settings
  end

  private

  def redirect_to_backlogs_settings
    redirect_to project_settings_backlogs_path(@project)
  end

  def log_rebuild_position_error
    logger.error("Tried to rebuild positions for project #{@project.identifier.inspect} but could not...")
    logger.error($!)
    logger.error($@)
  end
end
