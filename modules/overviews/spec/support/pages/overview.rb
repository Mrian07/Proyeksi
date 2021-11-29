

require 'support/pages/page'

require_relative '../../../../grids/spec/support/pages/grid'

module Pages
  class Overview < ::Pages::Grid
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def path
      project_overview_path(project)
    end
  end
end
