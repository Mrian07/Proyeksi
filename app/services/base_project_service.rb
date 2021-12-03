#-- encoding: UTF-8

class BaseProjectService
  def initialize(project)
    self.project = project
  end

  private

  attr_accessor :project
end
