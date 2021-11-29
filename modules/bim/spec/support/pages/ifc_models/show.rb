

require_relative 'show_default'

module Pages
  module IfcModels
    class Show < ::Pages::IfcModels::ShowDefault
      attr_accessor :id

      def initialize(project, id)
        super(project)
        self.id = id
      end

      private

      def path
        bcf_project_ifc_model_path(project, id)
      end
    end
  end
end
