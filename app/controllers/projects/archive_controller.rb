#-- encoding: UTF-8



class Projects::ArchiveController < ApplicationController
  before_action :find_project_by_project_id
  before_action :require_admin

  def create
    change_status_action(:archive)
  end

  def destroy
    change_status_action(:unarchive)
  end

  private

  def change_status_action(status)
    service_call = change_status(status)

    if service_call.success?
      redirect_to(project_path_with_status)
    else
      flash[:error] = t(:"error_can_not_#{status}_project",
                        errors: service_call.errors.full_messages.join(', '))
      redirect_back fallback_location: project_path_with_status
    end
  end

  def change_status(status)
    "Projects::#{status.to_s.camelcase}Service"
      .constantize
      .new(user: current_user, model: @project)
      .call
  end

  def project_path_with_status
    acceptable_params = params.permit(:status).to_h.compact.select { |_, v| v.present? }

    projects_path(acceptable_params)
  end
end
