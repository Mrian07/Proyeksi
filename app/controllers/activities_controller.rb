#-- encoding: UTF-8

class ActivitiesController < ApplicationController
  menu_item :activity
  before_action :find_optional_project,
                :verify_activities_module_activated,
                :determine_date_range,
                :determine_subprojects,
                :determine_author

  after_action :set_session

  accept_key_auth :index

  def index
    @activity = Activities::Fetcher.new(User.current,
                                        project: @project,
                                        with_subprojects: @with_subprojects,
                                        author: @author,
                                        scope: activity_scope)

    events = @activity.events(@date_from, @date_to)

    respond_to do |format|
      format.html do
        respond_html(events)
      end
      format.atom do
        respond_atom(events)
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    op_handle_warning "Failed to find all resources in activities: #{e.message}"
    render_404 I18n.t(:error_can_not_find_all_resources)
  end

  private

  def verify_activities_module_activated
    render_403 if @project && !@project.module_enabled?('activity')
  end

  def determine_date_range
    @days = Setting.activity_days_default.to_i

    if params[:from]
      begin
        ; @date_to = params[:from].to_date + 1.day;
      rescue StandardError;
      end
    end

    @date_to ||= User.current.today + 1.day
    @date_from = @date_to - @days
  end

  def determine_subprojects
    @with_subprojects = if params[:with_subprojects].nil?
                          Setting.display_subprojects_work_packages?
                        else
                          params[:with_subprojects] == '1'
                        end
  end

  def determine_author
    @author = params[:user_id].blank? ? nil : User.active.find(params[:user_id])
  end

  def respond_html(events)
    @events_by_day = events.group_by { |e| e.event_datetime.in_time_zone(User.current.time_zone).to_date }
    render layout: !request.xhr?
  end

  def respond_atom(events)
    title = t(:label_activity)
    if @author
      title = @author.name
    elsif @activity.scope.size == 1
      title = t("label_#{@activity.scope.first.singularize}_plural")
    end
    render_feed(events, title: "#{@project || Setting.app_title}: #{title}")
  end

  def activity_scope
    if params[:event_types]
      params[:event_types]
    elsif session[:activity]
      session[:activity]
    elsif @author.nil?
      :default
    else
      :all
    end
  end

  def set_session
    session[:activity] = @activity.scope
  end
end
