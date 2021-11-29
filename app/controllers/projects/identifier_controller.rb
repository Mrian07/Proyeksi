#-- encoding: UTF-8



class Projects::IdentifierController < ApplicationController
  before_action :find_project_by_project_id
  before_action :authorize

  def show; end

  def update
    service_call = Projects::UpdateService
                     .new(user: current_user,
                          model: @project)
                     .call(identifier: permitted_params.project[:identifier])

    if service_call.success?
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to project_settings_general_path(@project)
    else
      render action: 'show'
    end
  end
end
