#-- encoding: UTF-8

class Reports::ResponsibleReport < Reports::Report
  def self.report_type
    'responsible'
  end

  def field
    @field ||= 'responsible_id'
  end

  def rows
    @rows ||= @project.members.map(&:user).sort
  end

  def data
    @data ||= WorkPackage.by_responsible(@project)
  end

  def title
    @title ||= WorkPackage.human_attribute_name(:responsible)
  end
end
