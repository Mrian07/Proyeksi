
require_relative '../page'

module Pages
  module Projects
    class Destroy < ::Pages::Page
      def initialize(project)
        @project = project
      end

      private

      def path
        confirm_destroy_project_path(@project)
      end
    end
  end
end
