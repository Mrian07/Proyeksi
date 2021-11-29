#-- encoding: UTF-8



class BacklogsSettingsController < ApplicationController
  layout 'admin'
  menu_item :backlogs_settings

  before_action :require_admin
  before_action :check_valid_settings, only: :update

  def show; end

  def update
    Setting["plugin_openproject_backlogs"] = update_settings
    flash[:notice] = I18n.t(:notice_successful_update)

    redirect_to action: :show
  end

  def show_local_breadcrumb
    true
  end

  def default_breadcrumb
    I18n.t(:label_backlogs)
  end

  private

  def check_valid_settings
    story_types = update_settings[:story_types]
    task_type = update_settings[:task_type]

    if story_types.include?(task_type)
      flash[:error] = I18n.t(:error_backlogs_task_cannot_be_story)
      redirect_to action: :show
    end
  end

  def update_settings
    @update_settings ||= permitted_params.backlogs_admin_settings.to_h
  end
end
