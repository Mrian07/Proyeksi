#-- encoding: UTF-8

class Reports::ReportsService
  class_attribute :report_types

  def self.add_report(report)
    self.report_types ||= {}
    self.report_types[report.report_type] = report
  end

  def self.has_report_for?(report_type)
    self.report_types.has_key? report_type
  end

  # automate this? by cycling through each instance of Reports::Report? or is this to automagically?
  # and there is no reason, why plugins shouldn't be able to use this to add their own customized reports...
  add_report Reports::SubprojectReport
  add_report Reports::AuthorReport
  add_report Reports::AssigneeReport
  add_report Reports::ResponsibleReport
  add_report Reports::TypeReport
  add_report Reports::PriorityReport
  add_report Reports::CategoryReport
  add_report Reports::VersionReport

  def initialize(project)
    raise 'You must provide a project to report upon' unless project&.is_a?(Project)

    @project = project
  end

  def report_for(report_type)
    report_klass = self.class.report_types[report_type]
    report_klass&.new(@project)
  end
end
