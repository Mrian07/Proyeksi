#-- encoding: UTF-8

class Reports::AuthorReport < Reports::Report
  def self.report_type
    'author'
  end

  def field
    'author_id'
  end

  def rows
    @rows ||= @project.members.map(&:user).sort
  end

  def data
    @data ||= WorkPackage.by_author(@project)
  end

  def title
    @title ||= WorkPackage.human_attribute_name(:author)
  end
end
