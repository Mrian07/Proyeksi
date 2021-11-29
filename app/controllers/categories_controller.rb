#-- encoding: UTF-8



class CategoriesController < ApplicationController
  menu_item :settings_categories
  model_object Category
  before_action :find_model_object, except: %i[new create]
  before_action :find_project_from_association, except: %i[new create]
  before_action :find_project, only: %i[new create]
  before_action :authorize

  def new
    @category = @project.categories.build
  end

  def create
    @category = @project.categories.build
    @category.attributes = permitted_params.category

    if @category.save
      respond_to do |format|
        format.html do
          flash[:notice] = I18n.t(:notice_successful_create)
          redirect_to project_settings_categories_path(@project)
        end
        format.js do
          render locals: { project: @project, category: @category }
        end
      end
    else
      respond_to do |format|
        format.html do
          render action: :new
        end
        format.js do
          render(:update) { |page| page.alert(@category.errors.full_messages.join('\n')) }
        end
      end
    end
  end

  def update
    @category.attributes = permitted_params.category
    if @category.save
      flash[:notice] = I18n.t(:notice_successful_update)
      redirect_to project_settings_categories_path(@project)
    else
      render action: 'edit'
    end
  end

  def destroy
    @issue_count = @category.work_packages.size
    if @issue_count == 0
      # No issue assigned to this category
      @category.destroy
      redirect_to project_settings_categories_path(@project)
      return
    elsif params[:todo]
      reassign_to = @project.categories.find_by(id: params[:reassign_to_id]) if params[:todo] == 'reassign'
      @category.destroy(reassign_to)
      redirect_to project_settings_categories_path(@project)
      return
    end
    @categories = @project.categories - [@category]
  end

  private

  # Wrap ApplicationController's find_model_object method to set
  # @category instead of just @category
  def find_model_object
    super
    @category = @object
  end

  def find_project
    @project = Project.find(params[:project_id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
