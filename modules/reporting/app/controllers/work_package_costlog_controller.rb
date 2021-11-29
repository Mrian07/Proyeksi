

class WorkPackageCostlogController < ApplicationController
  model_object WorkPackage

  menu_item :work_packages
  before_action :find_objects
  before_action :authorize
  before_action :redirect_when_outside_project

  def index
    filters = { operators: {}, values: {} }

    if @work_package
      work_package_ids = @work_package.self_and_descendants.pluck(:id)

      filters[:operators][:work_package_id] = "="
      filters[:values][:work_package_id] = work_package_ids
    end

    filters[:operators][:project_id] = "="
    filters[:values][:project_id] = [@project.id.to_s]

    respond_to do |format|
      format.html do
        session[CostQuery.name.underscore.to_sym] = { filters: filters, groups: { rows: [], columns: [] } }
        redirect_to_cost_reports
      end
      format.all do
        redirect_to_cost_reports
      end
    end
  end

  private

  ##
  # only single work packages are handled here
  # redirect to cost reports for anything else
  def redirect_when_outside_project
    if @project.nil?
      redirect_to_cost_reports
    end
  end

  ##
  # We need to find potentially three objects
  # 1. Work package from :work_package_id and its #project
  # 2. Cost Type from param
  def find_objects
    find_model_object_and_project :work_package_id

    if params[:cost_type_id].present?
      @cost_type = CostType.find(params[:cost_type_id])
    end
  end

  def redirect_to_cost_reports
    if @cost_type
      redirect_to controller: "/cost_reports", action: "index", project_id: @project, unit: @cost_type.id
    else
      redirect_to controller: "/cost_reports", action: "index", project_id: @project
    end
  end
end
