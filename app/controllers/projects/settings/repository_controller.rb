#-- encoding: UTF-8



class Projects::Settings::RepositoryController < Projects::SettingsController
  menu_item :settings_repository

  def show
    @repository = @project.repository || new_repository
  end

  private

  def new_repository
    return unless params[:scm_vendor]

    service = SCM::RepositoryFactoryService.new(@project, params)
    if service.build_temporary
      @repository = service.repository
    else
      logger.error("Cannot create repository for #{params[:scm_vendor]}")
      flash[:error] = service.build_error
      nil
    end
  end
end
