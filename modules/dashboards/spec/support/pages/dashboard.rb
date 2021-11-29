

require 'support/pages/page'

require_relative '../../../../grids/spec/support/pages/grid'

module Pages
  class Dashboard < ::Pages::Grid
    attr_accessor :project

    def initialize(project)
      self.project = project
    end

    def path
      project_dashboards_path(project)
    end
  end
end
