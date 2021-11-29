#-- encoding: UTF-8



class News::CommentsController < ApplicationController
  default_search_scope :news
  model_object Comment, scope: [News => :commented]
  before_action :find_object_and_scope
  before_action :authorize

  def create
    @comment = Comment.new(permitted_params.comment)
    @comment.author = User.current
    if @news.comments << @comment
      flash[:notice] = I18n.t(:label_comment_added)
    end

    redirect_to news_path(@news)
  end

  def destroy
    @comment.destroy
    redirect_to news_path(@news)
  end
end
