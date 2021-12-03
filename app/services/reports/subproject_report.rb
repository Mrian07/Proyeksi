#-- encoding: UTF-8

class Reports::SubprojectReport < Reports::Report
  def self.report_type
    'subproject'
  end

  def field
    'project_id'
  end

  def rows
    @project.descendants.visible
  end

  def data
    WorkPackage.by_subproject(@project) || []
  end

  def title
    I18n.t(:label_subproject_plural)
  end
end
