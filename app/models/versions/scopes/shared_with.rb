#-- encoding: UTF-8



module Versions::Scopes
  module SharedWith
    extend ActiveSupport::Concern

    class_methods do
      # Returns a scope of the Versions available
      # in the project either because the project defined it itself
      # or because it was shared with it
      def shared_with(project)
        if project.persisted?
          shared_versions_on_persisted(project)
        else
          shared_versions_by_system
        end
      end

      protected

      def shared_versions_on_persisted(project)
        includes(:project)
          .where(projects: { id: project.id })
          .or(shared_versions_by_system)
          .or(shared_versions_by_tree(project))
          .or(shared_versions_by_hierarchy_or_descendants(project))
          .or(shared_versions_by_hierarchy(project))
      end

      def shared_versions_by_tree(project)
        root = project.root? ? project : project.root

        includes(:project)
          .merge(Project.active)
          .where(projects: { id: root.self_and_descendants.select(:id) })
          .where(sharing: 'tree')
      end

      def shared_versions_by_hierarchy_or_descendants(project)
        includes(:project)
          .merge(Project.active)
          .where(projects: { id: project.ancestors.select(:id) })
          .where(sharing: %w(hierarchy descendants))
      end

      def shared_versions_by_hierarchy(project)
        rolled_up(project)
          .where(sharing: 'hierarchy')
      end

      def shared_versions_by_system
        includes(:project)
          .merge(Project.active)
          .where(sharing: 'system')
      end
    end
  end
end
