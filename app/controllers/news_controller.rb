#-- encoding: UTF-8



class NewsController < ApplicationController
  include PaginationHelper
  include Layout

  default_search_scope :news

  before_action :find_news_object, except: %i[new create index]
  before_action :find_project_from_association, except: %i[new create index]
  before_action :find_project, only: %i[new create]
  before_action :authorize, except: [:index]
  before_action :find_optional_project, only: [:index]
  accept_key_auth :index

  def index
    scope = @project ? @project.news : News.all

    @newss = scope.merge(News.latest_for(current_user, count: 0))
                  .page(page_param)
                  .per_page(per_page_param)

    respond_to do |format|
      format.html do
        render layout: layout_non_or_no_menu
      end
      format.atom do
        render_feed(@newss,
                    title: (@project ? @project.name : Setting.app_title) + ": #{I18n.t(:label_news_plural)}")
      end
    end
  end

  current_menu_item :index do
    :news
  end

  def show
    @comments = @news.comments
    @comments.reverse_order if User.current.wants_comments_in_reverse_order?
  end

  def new
    @news = News.new(project: @project, author: User.current)
  end

  def create
    @news = News.new(project: @project, author: User.current)
    @news.attributes = permitted_params.news
    if @news.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to controller: '/news', action: 'index', project_id: @project
    else
      render action: 'new'
    end
  end

  def edit; end

  def update
    @news.attributes = permitted_params.news
    if @news.save
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'show', id: @news
    else
      render action: 'edit'
    end
  end

  def destroy
    @news.destroy
    flash[:notice] = I18n.t(:notice_successful_delete)
    redirect_to action: 'index', project_id: @project
  end

  private

  def find_news_object
    @news = @object = News.find(params[:id].to_i)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_optional_project
    return true unless params[:project_id]

    @project = Project.find(params[:project_id])
    authorize
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
