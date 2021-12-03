#-- encoding: UTF-8

class Reports::Report
  def initialize(project)
    @project = project
  end

  def self.report_type
    'default'
  end

  def report_type
    self.class.report_type
  end

  def statuses
    @statuses ||= Status.all
  end

  # ---- every report needs to implement these methods to supply all needed data for a report -----
  def field
    raise NotImplementedError
  end

  def rows
    raise NotImplementedError
  end

  def data
    raise NotImplementedError
  end

  def title
    raise NotImplementedError
  end
end
