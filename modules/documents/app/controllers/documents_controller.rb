#-- encoding: UTF-8



class DocumentsController < ApplicationController
  include AttachableServiceCall
  default_search_scope :documents
  model_object Document
  before_action :find_project_by_project_id, only: %i[index new create]
  before_action :find_model_object, except: %i[index new create]
  before_action :find_project_from_association, except: %i[index new create]
  before_action :authorize

  def index
    @group_by = %w(category date title author).include?(params[:group_by]) ? params[:group_by] : 'category'
    documents = @project.documents
    @grouped =
      case @group_by
      when 'date'
        documents.group_by { |d| d.updated_at.to_date }
      when 'title'
        documents.group_by { |d| d.title.first.upcase }
      when 'author'
        documents.with_attachments.group_by { |d| d.attachments.last.author }
      else
        documents.includes(:category).group_by(&:category)
      end

    render layout: false if request.xhr?
  end

  def show
    @attachments = @document.attachments.order(Arel.sql('created_at DESC'))
  end

  def new
    @document = @project.documents.build
    @document.attributes = document_params
  end

  def create
    call = attachable_create_call ::Documents::CreateService,
                                  args: document_params.merge(project: @project)

    if call.success?
      flash[:notice] = I18n.t(:notice_successful_create)
      redirect_to project_documents_path(@project)
    else
      @document = call.result
      @errors = call.errors
      render action: 'new'
    end
  end

  def edit
    @categories = DocumentCategory.all
  end

  def update
    call = attachable_update_call ::Documents::UpdateService,
                                  model: @document,
                                  args: document_params

    if call.success?
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to action: 'show', id: @document
    else
      @document = call.result
      @errors = call.errors
      render action: 'edit'
    end
  end

  def destroy
    @document.destroy
    redirect_to controller: '/documents', action: 'index', project_id: @project
  end

  private

  def document_params
    params.fetch(:document, {}).permit('category_id', 'title', 'description')
  end
end
