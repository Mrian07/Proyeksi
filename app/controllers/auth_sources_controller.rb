#-- encoding: UTF-8



class AuthSourcesController < ApplicationController
  include PaginationHelper
  layout 'admin'

  before_action :require_admin
  before_action :block_if_password_login_disabled

  def index
    @auth_sources = AuthSource.page(page_param)
                    .per_page(per_page_param)

    render 'auth_sources/index'
  end

  def new
    @auth_source = auth_source_class.new
    render 'auth_sources/new'
  end

  def create
    @auth_source = auth_source_class.new permitted_params.auth_source
    if @auth_source.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to action: 'index'
    else
      render 'auth_sources/new'
    end
  end

  def edit
    @auth_source = AuthSource.find(params[:id])
    render 'auth_sources/edit'
  end

  def update
    @auth_source = AuthSource.find(params[:id])
    updated = permitted_params.auth_source
    updated.delete :account_password if updated[:account_password].blank?

    if @auth_source.update updated
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'index'
    else
      render 'auth_sources/edit'
    end
  end

  def test_connection
    @auth_method = AuthSource.find(params[:id])
    begin
      @auth_method.test_connection
      flash[:notice] = I18n.t(:notice_successful_connection)
    rescue StandardError => e
      flash[:error] = I18n.t(:error_unable_to_connect, value: e.message)
    end
    redirect_to action: 'index'
  end

  def destroy
    @auth_source = AuthSource.find(params[:id])
    if @auth_source.users.empty?
      @auth_source.destroy

      flash[:notice] = t(:notice_successful_delete)
    else
      flash[:warning] = t(:notice_wont_delete_auth_source)
    end
    redirect_to action: 'index'
  end

  protected

  def auth_source_class
    AuthSource
  end

  def default_breadcrumb
    if action_name == 'index'
      t(:label_auth_source_plural)
    else
      ActionController::Base.helpers.link_to(t(:label_auth_source_plural), ldap_auth_sources_path)
    end
  end

  def show_local_breadcrumb
    true
  end

  def block_if_password_login_disabled
    render_404 if OpenProject::Configuration.disable_password_login?
  end
end
