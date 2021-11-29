#-- encoding: UTF-8



class Projects::TemplatedController < ApplicationController
  before_action :find_project_by_project_id
  before_action :authorize

  def create
    change_templated_action(true)
  end

  def destroy
    change_templated_action(false)
  end

  private

  def change_templated_action(templated)
    service_call = Projects::UpdateService
                     .new(user: current_user,
                          model: @project)
                     .call(templated: templated)

    if service_call.success?
      flash[:notice] = t(:notice_successful_update)
      redirect_to project_settings_general_path(@project)
    else
      @errors = service_call.errors
      render template: 'projects/settings/general'
    end
  end
end
