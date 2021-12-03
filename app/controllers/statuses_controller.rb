#-- encoding: UTF-8

class StatusesController < ApplicationController
  include PaginationHelper

  layout 'admin'

  before_action :require_admin

  def index
    @statuses = Status.page(page_param)
                      .per_page(per_page_param)

    render action: 'index', layout: false if request.xhr?
  end

  def new
    @status = Status.new
  end

  def create
    @status = Status.new(permitted_params.status)
    if @status.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  def edit
    @status = Status.find(params[:id])
  end

  def update
    @status = Status.find(params[:id])
    if @status.update(permitted_params.status)
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'index'
    else
      render action: 'edit'
    end
  end

  def destroy
    status = Status.find(params[:id])
    if status.is_default?
      flash[:error] = I18n.t(:error_unable_delete_default_status)
    else
      status.destroy
      flash[:notice] = I18n.t(:notice_successful_delete)
    end
    redirect_to action: 'index'
  rescue StandardError
    flash[:error] = I18n.t(:error_unable_delete_status)
    redirect_to action: 'index'
  end

  def update_work_package_done_ratio
    if Status.update_work_package_done_ratios
      flash[:notice] = I18n.t(:notice_work_package_done_ratios_updated)
    else
      flash[:error] = I18n.t(:error_work_package_done_ratios_not_updated)
    end
    redirect_to action: 'index'
  end

  protected

  def default_breadcrumb
    if action_name == 'index'
      t(:label_work_package_status_plural)
    else
      ActionController::Base.helpers.link_to(t(:label_work_package_status_plural), statuses_path)
    end
  end

  def show_local_breadcrumb
    true
  end
end
