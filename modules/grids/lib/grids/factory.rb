#-- encoding: UTF-8



module Grids
  class Factory
    class << self
      def build(scope, user)
        attributes = ::Grids::Configuration.attributes_from_scope(scope)

        grid_class = attributes[:class]
        grid_project = project_from_id(attributes[:project_id])

        new_default(grid_class, grid_project, user)
      end

      private

      def new_default(klass, project, user)
        params = class_defaults(klass)

        if klass.reflect_on_association(:project)
          params[:project] = project
        end

        if klass.reflect_on_association(:user)
          params[:user] = user
        end

        klass.new(params)
      end

      def class_defaults(klass)
        params = ::Grids::Configuration.defaults(klass)

        params || { row_count: 4, column_count: 5, widgets: [] }
      end

      def project_from_id(id)
        Project.find(id) if id
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
