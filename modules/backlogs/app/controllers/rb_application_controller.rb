

# Base class of all controllers in Backlogs
class RbApplicationController < ApplicationController
  helper :rb_common

  before_action :load_sprint_and_project, :check_if_plugin_is_configured, :authorize

  skip_before_action :verify_authenticity_token, if: -> { Rails.env.test? }

  # Render angular layout to handle CSS loading
  # from the frontend
  layout 'angular/angular'

  private

  # Loads the project to be used by the authorize filter to determine if
  # User.current has permission to invoke the method in question.
  def load_sprint_and_project
    # because of strong params, we want to pluck this variable out right now,
    # otherwise it causes issues where we are doing `attributes=`.
    if (@sprint_id = params.delete(:sprint_id))
      @sprint = Sprint.find(@sprint_id)
      @project = @sprint.project
    end
    # This overrides sprint's project if we set another project, say a subproject
    @project = Project.find(params[:project_id]) if params[:project_id]
  end

  def check_if_plugin_is_configured
    settings = Setting.plugin_proyeksiapp_backlogs
    if settings['story_types'].blank? || settings['task_type'].blank?
      respond_to do |format|
        format.html { render template: 'shared/not_configured' }
      end
    end
  end
end
