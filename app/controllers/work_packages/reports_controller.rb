#-- encoding: UTF-8



class WorkPackages::ReportsController < ApplicationController
  menu_item :work_packages
  before_action :find_project_by_project_id, :authorize

  def report
    reports_service = Reports::ReportsService.new(@project)

    @reports = [
      reports_service.report_for('type'),
      reports_service.report_for('priority'),
      reports_service.report_for('assigned_to'),
      reports_service.report_for('responsible'),
      reports_service.report_for('author'),
      reports_service.report_for('version'),
      reports_service.report_for('category')
    ]

    @reports << reports_service.report_for('subproject') if @project.children.any?
  end

  def report_details
    @report = Reports::ReportsService
              .new(@project)
              .report_for(params[:detail])

    respond_to do |format|
      if @report
        format.html
      else
        format.html { redirect_to report_project_work_packages_path(@project) }
      end
    end
  end

  private

  def default_breadcrumb
    I18n.t(:label_summary)
  end
end
