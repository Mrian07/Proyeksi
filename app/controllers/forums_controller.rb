#-- encoding: UTF-8

class ForumsController < ApplicationController
  default_search_scope :messages
  before_action :find_project_by_project_id,
                :authorize
  before_action :new_forum, only: %i[new create]
  before_action :find_forum, only: %i[show edit update move destroy]
  accept_key_auth :show

  include SortHelper
  include WatchersHelper
  include PaginationHelper

  def index
    @forums = @project.forums
  end

  current_menu_item [:index, :show] do
    :forums
  end

  def show
    sort_init 'updated_at', 'desc'
    sort_update 'created_at' => "#{Message.table_name}.created_at",
                'replies' => "#{Message.table_name}.replies_count",
                'updated_at' => "#{Message.table_name}.updated_at"

    respond_to do |format|
      format.html do
        set_topics
        @message = Message.new
        render action: 'show', layout: !request.xhr?
      end
      format.json do
        set_topics

        render template: 'messages/index'
      end
      format.atom do
        @messages = @forum
                      .messages
                      .order(["#{Message.table_name}.sticked_on ASC", sort_clause].compact.join(', '))
                      .includes(:author, :forum)
                      .limit(Setting.feeds_limit.to_i)

        render_feed(@messages, title: "#{@project}: #{@forum}")
      end
    end
  end

  def set_topics
    @topics = @forum
                .topics
                .order(["#{Message.table_name}.sticked_on ASC", sort_clause].compact.join(', '))
                .includes(:author, last_reply: :author)
                .page(page_param)
                .per_page(per_page_param)
  end

  def new; end

  def create
    if @forum.save
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to action: 'index'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @forum.update(permitted_params.forum)
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'index'
    else
      render :edit
    end
  end

  def move
    if @forum.update(permitted_params.forum_move)
      flash[:notice] = t(:notice_successful_update)
    else
      flash.now[:error] = t('forum_could_not_be_saved')
      render action: 'edit'
    end
    redirect_to action: 'index'
  end

  def destroy
    @forum.destroy
    flash[:notice] = I18n.t(:notice_successful_delete)
    redirect_to action: 'index'
  end

  private

  def find_forum
    @forum = @project.forums.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def new_forum
    @forum = Forum.new(permitted_params.forum?)
    @forum.project = @project
  end
end
