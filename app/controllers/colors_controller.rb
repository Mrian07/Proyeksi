#-- encoding: UTF-8



class ColorsController < ApplicationController
  before_action :require_admin_unless_readonly_api_request

  layout 'admin'

  menu_item :colors

  def index
    @colors = Color.all.sort_by(&:name)
    respond_to do |format|
      format.html
    end
  end

  def show
    @color = Color.find(params[:id])
    respond_to do |_format|
    end
  end

  def new
    @color = Color.new
    respond_to do |format|
      format.html
    end
  end

  def create
    @color = Color.new(permitted_params.color)

    if @color.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to colors_path
    else
      flash.now[:error] = I18n.t('timelines.color_could_not_be_saved')
      render action: 'new'
    end
  end

  def edit
    @color = Color.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    @color = Color.find(params[:id])

    if @color.update(permitted_params.color)
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to colors_path
    else
      flash.now[:error] = I18n.t('timelines.color_could_not_be_saved')
      render action: 'edit'
    end
  end

  def confirm_destroy
    @color = Color.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def destroy
    @color = Color.find(params[:id])
    @color.destroy

    flash[:notice] = I18n.t(:notice_successful_delete)
    redirect_to colors_path
  end

  protected

  def default_breadcrumb
    if action_name == 'index'
      t('timelines.admin_menu.colors')
    else
      ActionController::Base.helpers.link_to(t('timelines.admin_menu.colors'), colors_path)
    end
  end

  def show_local_breadcrumb
    true
  end

  def require_admin_unless_readonly_api_request
    require_admin unless %w[index show].include? params[:action] and
                         api_request?
  end
end
