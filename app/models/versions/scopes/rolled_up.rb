#-- encoding: UTF-8

module Versions::Scopes
  module RolledUp
    extend ActiveSupport::Concern

    class_methods do
      # Returns a scope of the Versions defined on the project
      # itself or its descendants.
      def rolled_up(project)
        includes(:project)
          .merge(Project.active)
          .where(projects: { id: project.self_and_descendants.select(:id) })
      end
    end
  end
end
