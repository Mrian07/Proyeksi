#-- encoding: UTF-8



class WorkPackages::BulkController < ApplicationController
  before_action :find_work_packages
  before_action :authorize

  include ProjectsHelper
  include CustomFieldsHelper
  include RelationsHelper
  include QueriesHelper

  def edit
    setup_edit
  end

  def update
    @call = ::WorkPackages::Bulk::UpdateService
      .new(user: current_user, work_packages: @work_packages)
      .call(params: params)

    if @call.success?
      flash[:notice] = t(:notice_successful_update)
      redirect_back_or_default(controller: '/work_packages', action: :index, project_id: @project)
    else
      @bulk_errors = @call.errors
      setup_edit
      render action: :edit
    end
  end

  def destroy
    if WorkPackage.cleanup_associated_before_destructing_if_required(@work_packages, current_user, params[:to_do])
      destroy_work_packages(@work_packages)

      respond_to do |format|
        format.html do
          redirect_back_or_default(project_work_packages_path(@work_packages.first.project))
        end
        format.json do
          head :ok
        end
      end
    else
      respond_to do |format|
        format.html do
          render locals: { work_packages: @work_packages,
                           associated: WorkPackage.associated_classes_to_address_before_destruction_of(@work_packages) }
        end
        format.json do
          render json: { error_message: 'Clean up of associated objects required' }, status: 420
        end
      end
    end
  end

  private

  def setup_edit
    @available_statuses = @projects.map { |p| Workflow.available_statuses(p) }.inject(&:&)
    @custom_fields = @projects.map(&:all_work_package_custom_fields).inject(&:&)
    @assignables = possible_assignees
    @responsibles = @assignables
    @types = @projects.map(&:types).inject(&:&)
  end

  def destroy_work_packages(work_packages)
    work_packages.each do |work_package|
      WorkPackages::DeleteService
        .new(user: current_user,
             model: work_package.reload)
        .call
    rescue ::ActiveRecord::RecordNotFound
      # raised by #reload if work package no longer exists
      # nothing to do, work package was already deleted (eg. by a parent)
    end
  end

  def possible_assignees
    @projects.inject(Principal.all) do |scope, project|
      scope.where(id: Principal.possible_assignee(project))
    end
  end

  def user
    current_user
  end

  def default_breadcrumb
    I18n.t(:label_work_package_plural)
  end
end
